class StaticData < ActiveRecord::Base

  def self.cities
    ["Austin, TX",
     "Chicago, IL",
     "Dallas, TX",
     "Houston, TX",
     "San Antonio, TX"]
  end
end
