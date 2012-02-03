class Mytweet < ActiveRecord::Base
        validates :post, :presence => true, :uniqueness => true, :length => { :maximum => 140 }
end

