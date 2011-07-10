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
           if item.availability.to_date <= currenttime.to_date
              if item.availability.to_time.hour <= currenttime.to_time.hour
                 if (item.availability.to_time.hour == currenttime.to_time.hour) && \
                     (item.availability.to_time.min > currenttime.to_time.min)
                      next                                          
                  end
                 item.status = "expired"
                 item.save
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
                end
              logger.debug "before calling capturemoney"
              self.capturemoney(highestbid, item.id)
            end
          end
         end
       end
  
  end

def self.capturemoney(highestbid, id)
  logger.debug "entering capturemoney"
  user = User.find_by_id(highestbid.user_id)
  service = self.find_by_id(id)
  ccard = user.credit_card
  
  serviceorder = Order.create(:amount => highestbid.bidprice,                        
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
                       
  serviceorder.something
  local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
  result = serviceorder.purchase({ :ip => local_ip,
                          :billing_address => {
                          :name     => serviceorder.first_name + serviceorder.last_name,
                          :address1 => serviceorder.address,
                          :city     => serviceorder.city,
                          :state    => serviceorder.state_name,
                          :country  => serviceorder.country,
                          :zip      => serviceorder.zip
                          }
                         }
                        )
  service.status = "bought"
  service.save

end


end