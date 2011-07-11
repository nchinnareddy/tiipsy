require "socket"
class Servicelisting < ActiveRecord::Base
  
  has_many :bids, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  
  has_attached_file :photo  
    
def self.checkexpirations
      logger.debug "entering checkexpirations"
      currenttime = DateTime.now
      users = []
      logger.debug " #{currenttime}"
      list = self.find(:all)
        
       list.each do |item|
         if item.status == "active"
           logger.debug "ITEM IS ACTIVE"
           if item.availability.to_date < currenttime.to_date
              logger.debug "DATE IS EXPIRED"  
              item.status = "expired"
              item.save
           elsif (item.availability.to_date == currenttime.to_date) && (item.availability.to_time.hour < currenttime.to_time.hour)
                 logger.debug "HOUR IS EXPIRED"
                 item.status = "expired"
                 item.save
           elsif (item.availability.to_date == currenttime.to_date) && (item.availability.to_time.hour == currenttime.to_time.hour) && \
                 (item.availability.to_time.min > currenttime.to_time.min)
                  item.status = "expired"
                  item.save
           else
              next
              end
            
           if item.status == "expired"
              highestbid = nil
              item.bids.each do |bid|
               if highestbid == nil
                  highestbid = bid
                  next
                  end
               if bid.bidprice > highestbid.bidprice
                  highestbid = bid
                  end
#                 user = User.find_by_id(bid.user_id)
#                 users.add(user)
#                 Notifier.bid_expired_email(user).deliver  
                 end # do end
              logger.debug "before calling capturemoney"
              result = self.capturemoney(highestbid, item.id)
              logger.debug "after calling capturemoney"
              logger.debug "result value is: #{result}"
              if result == true
                 item.status = "bought"
                 item.save
               end
             end
          end
        end  
end

def self.capturemoney(highestbid, id)
  logger.debug "entering capturemoney"
  user = User.find_by_id(highestbid.user_id)
 # service = self.find_by_id(id)
  ccard = user.credit_card
  
  exp_bid_order = Order.create(:amount => highestbid.bidprice,                        
                        :first_name => ccard.first_name,
                        :last_name => ccard.last_name,
                        :card_type => ccard.card_type,
                        :card_number => ccard.card_number,
                        :card_verification => ccard.card_verification,
                        :card_expires_on => ccard.card_expires_on,
                        :address => ccard.address,
                        :city => ccard.city,
                        :state_name => ccard.state_name,
                        :country => ccard.country,
                        :zip => ccard.zip
                       )
                       
  local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
  result = exp_bid_order.purchase({ :ip => local_ip,
                          :billing_address => {
                          :name     => exp_bid_order.first_name + exp_bid_order.last_name,
                          :address1 => exp_bid_order.address,
                          :city     => exp_bid_order.city,
                          :state    => exp_bid_order.state_name,
                          :country  => exp_bid_order.country,
                          :zip      => exp_bid_order.zip
                          }
                         }
                        )
 end


end