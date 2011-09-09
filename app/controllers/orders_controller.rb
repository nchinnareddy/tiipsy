
class OrdersController < ApplicationController
  
def create
   ccard = current_user.credit_card
   @order = Order.create(:amount => params[:order][:amount],
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
  @order.servicelisting_id = params[:order][:servicelisting_id]
  @order.user_id = current_user.id
  @order.ip_address = request.remote_ip
  @order.description = "Buynow"
  @servicelisting = Servicelisting.find(@order.servicelisting_id)
  @product = @servicelisting.title
  @cost = @servicelisting.price
  @desc = @servicelisting.description
  @barowner_email = @servicelisting.email
  if @order.save
      if @order.purchase
        @servicelisting.winner_id = @order.user_id
        @servicelisting.status = "Closed"
        @servicelisting.availability = DateTime.now
        @servicelisting.save
        #all_biders = Bid.find(:all, :conditions => ["servicelisting_id=?",@order.servicelisting_id])
        all_biders = Bid.where("servicelisting_id=?",@order.servicelisting_id)
        all_biders.each do |bidder|
          logger.debug " #{bidder.user_id}"
          @user_details = User.where("id = ?", bidder.user_id).first
          bidder_email = @user_details.email
          Notifier.send_mail_to_each_bidder_after_buy(bidder_email,@product,@cost,@desc).deliver
        end
        # test code start
        Notifier.send_mail_to_user_after_buy(current_user.email,@product,@cost,@desc).deliver
        Notifier.send_mail_to_admin_after_buy(@product,@cost,@desc).deliver
        Notifier.send_mail_to_barowner_after_buy(@barowner_email,@product,@cost,@desc).deliver
        render :action => "success"
      else
        flash[:notice] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction.  Re-enter your credit card details"
       redirect_to new_user_credit_card_path(current_user)
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