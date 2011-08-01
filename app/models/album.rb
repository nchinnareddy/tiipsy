class Album < ActiveRecord::Base
  has_many :photos
  validates_presence_of :bussiness_name
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
  end
  
end
