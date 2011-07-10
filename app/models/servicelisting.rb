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
                 highestbid = nil
                 item.bids.each do |bid|
                   if highestbid == nil
                     highestbid = bid
                   end
                   if bid.bidprice > highestbid.bidprice
                      highestbid = bid
                   end
                 user = User.find_by_id(bid.user_id)
                 Notifier.bid_expired_email(user).deliver  
             end
             capturemoney(highestbid)
            end
          end
         end
       end
  
  end

def capturemoney(highestbid)
  user = User.find_by_id(highestbid.user_id)
  ccard = user.credit_card
  @order = Order.create(:amount => highestbid.bidprice,                        
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
  
end

def standard_purchase_options
    {
        :ip => request.remote_ip,
        :billing_address => {
        :name     => @order.first_name + @order.last_name,
        :address1 => @order.address,
        :city     => @order.city,
        :state    => @order.state_name,
        :country  => @order.country,
        :zip      => @order.zip
       }
     }
end


end