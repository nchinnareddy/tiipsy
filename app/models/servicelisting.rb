include Geokit::Geocoders
require "socket"
class Servicelisting < ActiveRecord::Base
  
  has_many :bids
  has_many :orders
  
  has_attached_file :photo  
   
def self.search(search)
  if search
    find(:all, :conditions => ['description LIKE ?', "%#{search}%"])
  else
    find(:all)
  end
end

def self.checkexpirations
      logger.debug "entering checkexpirations"
      currenttime = DateTime.now
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
                 (item.availability.to_time.min < currenttime.to_time.min)
                  item.status = "expired"
                  item.save
           else
              next
              end
            
           if item.status == "expired"
              #highestbid = nil
              #item.bids.each do |bid|
              #   if highestbid == nil
              #      highestbid = bid
              #      next
              #   end
              #   if bid.bidprice > highestbid.bidprice
              #      highestbid = bid
              #   end
#                   user = User.find_by_id(bid.user_id)
#                   users.add(user)
#                   Notifier.bid_expired_email(user).deliver  
              #  end # do end
                capture_result = false
                highestbid_id = item.bids.maximum(:id,:conditions=>"bidprice") 
                highestbid = item.bids.find(highestbid_id)
                if highestbid != nil
                  capture_result = self.capturemoney(highestbid, item.id)
                end
              if capture_result == true
                 item.status = "Closed"
                 item.winner_id = highestbid.user_id
                 user = User.find_by_id(highestbid.user_id)
                 item.save
                 Notifier.send_mail_to_user_after_bid_closed(user.email,highestbid.bidprice,item.title,item.description).deliver if user
                 all_biders = Bid.where("servicelisting_id=?",item.id)
                 all_biders.each do |bidder|
                    logger.debug " #{bidder.user_id}"
                    @user_details = User.where("id = ?", bidder.user_id).first
                    bidder_email = @user_details.email
                    Notifier.send_mail_to_each_bidder_after_bid_closed(bidder_email,highestbid.bidprice,item.title,item.description).deliver
                end
               end
           end
          end
        end  
end

def self.capturemoney(highestbid, service_id)
  logger.debug "entering capturemoney"
  user = User.find_by_id(highestbid.user_id)
  #authorized_order =  Order.where("user_id = ? AND servicelisting_id = ? AND state = ? ", highestbid.user_id, service_id, 'authorized')
  authorized_order  = Order.find_by_user_id_and_servicelisting_id_and_state(highestbid.user_id,service_id,'authorized')
  athorizationlimit = ((authorized_order.amount) * 100) + ((15/(authorized_order.amount))* 100)
  ccard = user.credit_card
  local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
  
   if ((highestbid.bidprice) * 100) <= athorizationlimit
     capture_result = authorized_order.capture_payment
   else
     void_result = authorized_order.void
     if void_result.success?           
       exp_bid_order = Order.create( :amount => highestbid.bidprice,
                                     :description => "Bidding",
                                     :user_id => highestbid.user_id,
                                     :servicelisting_id => service_id,
                                     :ip_address => local_ip,
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
          
       capture_result = exp_bid_order.purchase
   end
  end   
   if capture_result.success?
     return true
   else
     return false
   end
 
end                                   
                              
                               
end
