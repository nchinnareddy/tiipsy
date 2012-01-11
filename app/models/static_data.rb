class StaticData < ActiveRecord::Base

  def self.cities
    ["Austin, TX",
     "Chicago, IL",
     "Dallas, TX",
     "Houston, TX",
     "San Antonio, TX"]
  end

  def self.servicelisting_cities
    ["Austin, TX",
     "Chicago, IL"]
  end
end
