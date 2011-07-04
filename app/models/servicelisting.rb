class Servicelisting < ActiveRecord::Base
  
  has_many :bids, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  
  has_attached_file :photo  
    
  def self.checkexpirations
      logger.debug "entering checkexpirations"
      currenttime = DateTime.now
      logger.debug " #{currenttime}"
      list = self.find(:all)
        
       list.each do |item|
         if item.status == "active"
           if item.availability.to_date <= currenttime.to_date
              if item.availability.to_time.hour <= currenttime.to_time.hour
                 if (item.availability.to_time.hour == currenttime.to_time.hour) && \
                     (item.availability.to_time.min > currenttime.to_time.min)
                      next                                          
                  end
                 item.status = "expired"
                 item.save
                 item.bids.each do |bid|
                 user = User.find_by_id(bid.user_id)
                 Notifier.bid_expired_email(user).deliver  
               end                           
            end
          end
         end
       end
  
  end



end