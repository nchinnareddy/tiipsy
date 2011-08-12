
class OrdersController < ApplicationController
  
def create
   ccard = current_user.credit_card
   @order = Order.create(:first_name => ccard.first_name,
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
  @order.amount = params[:order][:amount]
  @order.servicelisting_id = params[:order][:servicelisting_id]
  @order.user_id = current_user.id
  @order.ip_address = request.remote_ip
  @order.description = "Buynow"
  @servicelisting = Servicelisting.find(@order.servicelisting_id)
  
  if @order.save
      if @order.purchase
        @servicelisting.winner_id = @order.user_id
        @servicelisting.save
        render :action => "success"
      else
       render :action => "failure"
      end
  end 
end
   
def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => @order.card_type,
      :number             => @order.card_number,
      :verification_value => @order.card_verification,
      :month              => @order.card_expires_on.month,
      :year               => @order.card_expires_on.year,
      :first_name         => @order.first_name,
      :last_name          => @order.last_name
    )
  end
  
  def success
    
  end
 
end