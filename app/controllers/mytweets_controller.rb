class MytweetsController < ApplicationController
        require 'rubygems'
        require 'twitter'
        require 'oauth'
        require 'open-uri'
        require 'rexml/document'
        #require 'pp'
        require 'net/http'
        before_filter :authenticate
        def index
                @mytweet=Mytweet.new
                @mytweets=Mytweet.find(:all, :order=> "created_at DESC")
        end
        def create
                response = $access_token.post("http://api.twitter.com/1/statuses/update.json", {:status =>"#{params[:post]}"})
                 logger.info response.inspect
                 flash[:notice]="Added one new tweet..!"
                redirect_to "/mytweets"
        end
        def authenticate
		if params[:oauth_token].nil? && session[:request_token].nil?
		         @consumer=OAuth::Consumer.new "mj6uyAzqiUQahg4vf97tzQ", "tmiACDNBnaXY1NpNydw77ctuJgM5qxolozdS8qRI", {:site=>"http://api.twitter.com"}
                         session[:request_token] ||=@consumer.get_request_token(:oauth_callback => "http://192.168.33.159:3001/mytweets")
                         redirect_to session[:request_token].authorize_url
                else
                         $access_token ||=session[:request_token].get_access_token
                         @response=$access_token.get "https://api.twitter.com/1/statuses/home_timeline.xml?include_entities=true"
                                        t_url = @response.body
                                        doc = REXML::Document.new(t_url)
                                       @main_arr=[]
                                        arr1=[]
                                        hashing={}
                                        h={}
                                        arr2=[]
                                        main = doc.root.length-1

                                        main.times do |main|
                                                arr2 << doc.root.elements[main+1]
                                        end
                                        v = arr2.compact.length

                                        v.times do |main1|
                                                a = main1+1
                                                if !doc.root.elements[a].nil? && !doc.root.elements[a].text.nil?
                                                        h = {}
                                                        min= doc.root.elements[a].length-1

                                                        min.times do |min|
                                                                b = min+1
                                                                if !doc.root.elements[a].elements[b].nil? && !doc.root.elements[a].elements[b].text.nil?
                                                                        h[doc.root.elements[a].elements[b].name]= doc.root.elements[a].elements[b].text
                                                                end
                                                        end
                                                        if h !={}
                                                                @main_arr << h
                                                        end
                                                end
                                        end
                                #render :text=> @main_arr.inspect and return false
                 end
        end
def destroy
        del=$access_token.post("http://api.twitter.com/1/statuses/destroy/#{params[:id]}.xml")
        #render :text=>del.body.inspect and return false
        flash[:notice]="One tweet deleted successfully..!"
        redirect_to "/mytweets"
end

end

