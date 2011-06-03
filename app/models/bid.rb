class Bid < ActiveRecord::Base
  
  belongs_to :servicelisting
  belongs_to :user
  
  
end
