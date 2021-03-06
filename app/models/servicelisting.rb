include Geokit::Geocoders
require "socket"
class Servicelisting < ActiveRecord::Base
  
  has_many :bids
  has_many :orders
  
  has_attached_file :photo,
                    :styles => {:thumb => "150x150!"},
                    :default_url => '/images/servicelisting-noimage.jpg'

   
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
                  capture_result = self.braintree_capture(highestbid, item.id)
                end
              if capture_result == true
                 item.status = "Closed"
                 item.winner_id = highestbid.user_id
                 user = User.find_by_id(highestbid.user_id)
                 item.save
                 #mail to highest bidder 
                 Notifier.send_mail_to_user_after_bid_closed(user.email,highestbid.bidprice,item.title,item.description).deliver if user
                 Notifier.send_mail_to_barowner_after_bid_closed(item.email,highestbid.bidprice,item.title,item.description).deliver
                 
                 all_biders = Bid.where("servicelisting_id=?",item.id)
                 all_biders.each do |bidder|
                    if bidder.user_id != highestbid.user_id
                      logger.debug " #{bidder.user_id}"
                      void_result = self.braintree_void(bidder.user_id,item.id)
                      print "-----voided-----"
                      @user_details = User.where("id = ?", bidder.user_id).first
                      bidder_email = @user_details.email
                      Notifier.send_mail_to_each_bidder_after_bid_closed(bidder_email,highestbid.bidprice,item.title,item.description).deliver
                    end
                end
               end
           end
          end
        end  
end

def self.braintree_void(bid_user_id, service_id)
  authorized_order  = Order.find_by_user_id_and_servicelisting_id_and_state(bid_user_id,service_id,'authorized')
  local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
  void_result = Braintree::Transaction.void(authorized_order.bttoken)
  
  if void_result.success?
    authorized_order.state = 'void'
    authorized_order.save
    return true
  else 
    return false
  end
end

def self.braintree_capture(highestbid, service_id)
  logger.debug "entering capturemoney"
  user = User.find_by_id(highestbid.user_id)
  #authorized_order =  Order.where("user_id = ? AND servicelisting_id = ? AND state = ? ", highestbid.user_id, service_id, 'authorized')
  authorized_order  = Order.find_by_user_id_and_servicelisting_id_and_state(highestbid.user_id,service_id,'authorized')
  #athorizationlimit = ((authorized_order.amount) * 100) + ((15/(authorized_order.amount))* 100)
  athorizationlimit = authorized_order.amount
  #ccard = user.credit_card
  local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}


  # authorized amount is always $1 so we void the transaction and send a new one. 
  #void authorization
    void_result = Braintree::Transaction.void(authorized_order.bttoken)
    
    if void_result.success? 
      authorized_order.state = 'void'
      authorized_order.save
    else
      logger.debug "void failed"
    end
    
   # create new authorization  and settle
     cc = CreditCard.where("user_id =? ", authorized_order.user_id).first
     result = Braintree::Transaction.sale(
       :amount => highestbid.bidprice,
       :customer_id => cc.user_id,
       :payment_method_token => cc.bttoken
     )

     if result.success?
       #send transaction for settlement 
       settlement_result = Braintree::Transaction.submit_for_settlement(result.transaction.id)
       if settlement_result.success?
          p "settlement successful"
          puts "success!: #{result.transaction.id}"
          begin 
            @order = Order.create(:amount => highestbid.bidprice ,
            :first_name => "ccard.first_name",
            :last_name => "ccard.last_name",
            :card_type => "ccard.card_type",
            :card_number => "ccard.card_number",
            :card_verification => "ccard.card_verification",
            :card_expires_on => "ccard.card_expires_on",
            :address => "ccard.address",
            :city => "ccard.city",
            :state_name => "ccard.state_name",
            :country => "ccard.country",
            :zip => "ccard.zip", 
            :user_id => authorized_order.user_id, 
            :ip_address => local_ip,
            :description => "Bid",
            :bttoken => result.transaction.id,
            :servicelisting_id => service_id
            )
          rescue 
            p "Something when wrong in Order creation of bid finalized"
            return false
          end 

          #when order is succesful then update services listing and send email notification to all active users
          @order.state = 'paid'
          if @order.save
             return true
          end 
       else 
         p settlement_result.errors
         return false
       end
     elsif result.transaction
       puts "Error processing transaction:"
       puts "  code: #{result.transaction.processor_response_code}"
       puts "  text: #{result.transaction.processor_response_text}"
       return false
     else
       p result.errors
       return false
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

  puts "-------highestbid.bidprice---"
  puts highestbid.bidprice
  puts "--------athorizationlimit------"
  puts athorizationlimit

   if ((highestbid.bidprice) * 100) <= athorizationlimit
     #Adjust Amount on the Order to capture the current bid amount 
    authorized_order.amount = highestbid.bidprice
    authorized_order.save
    capture_result = authorized_order.capture_payment 
   else
     void_result = authorized_order.void
     if void_result     
       puts "--inside void and create new code"      
       exp_bid_order = Order.create( :amount => highestbid.bidprice,
                                     :description => "Bidding",
                                     :user_id => highestbid.user_id,
                                     :servicelisting_id => service_id,
                                     :ip_address => local_ip,
                                     :first_name => "ccard.first_name",
                                     :last_name => "ccard.last_name",
                                     :card_type => "ccard.card_type",
                                     :card_number => "ccard.card_number",
                                     :card_verification => "ccard.card_verification",
                                     :card_expires_on => "ccard.card_expires_on",
                                     :address => "ccard.address",
                                     :city => "ccard.city",
                                     :state_name => "ccard.state_name",
                                     :country => "ccard.country",
                                     :zip => "ccard.zip",
                                     :express_token => authorized_order.express_token , :express_payer_id => authorized_order.express_payer_id
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

def self.void_authorization(bid_user_id, service_id)
  authorized_order  = Order.find_by_user_id_and_servicelisting_id_and_state(bid_user_id,service_id,'authorized')
  local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
  void_result = authorized_order.void_authorization 
  if void_result 
    return true
  else 
    return false
  end
end                            
                              
                               
end
