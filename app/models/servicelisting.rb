class Servicelisting < ActiveRecord::Base
  
  has_many :bids
  
  has_attached_file :photo  
  
end
