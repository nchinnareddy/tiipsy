class OrdersController < ApplicationController
  #ssl_required :create, :credit_card
  if ENV['RAILS_ENV'] == "development"
    #ssl_required :create, :credit_card
  else
    ssl_required :create, :credit_card
  end
  
  def bids_orders    
      #pp
      @order.express_token = params[:order][:express_token]
      @order.express_payer_id = params[:order][:express_payer_id]
      
      if @order.save
        if @order.authorize_payment
          flash[:notice] = "You are authorized to bid on: #{@servicelisting.title}"
          redirect_to root_path
        else
          flash[:notice] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction. Re-enter your credit card details"
          #redirect_to new_user_credit_card_path(current_user)
          redirect_to root_path
        end
      end   
  end
  
  def braintree_buynow(order)  
    result = Braintree::Transaction.sale(
      :amount => "1000.00",
      :credit_card => {
        :number => "5105105105105100",
        :expiration_date => "05/12"
      }
    )

    if result.success?
      puts "success!: #{result.transaction.id}"
    elsif result.transaction
      puts "Error processing transaction:"
      puts "  code: #{result.transaction.processor_response_code}"
      puts "  text: #{result.transaction.processor_response_text}"
    else
      p result.errors
    end

  end
  
  def create
    #create braintree sale
    cc = CreditCard.where("user_id =? ", current_user.id).first
    result = Braintree::Transaction.sale(
      :amount => params[:order][:amount],
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
           @order = Order.create(:amount => params[:order][:amount] ,
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
           :user_id => current_user.id, 
           :ip_address => request.remote_ip,
           :description => "Buynow",
           :bttoken => result.transaction.id,
           :servicelisting_id => params[:order][:servicelisting_id]
           )
         rescue 
           p "Something when wrong in Order creation of Buying"
           flash[:error] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction.  Re-enter your credit card details"
           redirect_to root_path
         end 

         #when order is succesful then update services listing and send email notification to all active users
         @order.state = 'paid'
         if @order.save
           @servicelisting = Servicelisting.find(@order.servicelisting_id)
           @product = @servicelisting.title
           @cost = @servicelisting.price
           @no_of_guests = @servicelisting.no_of_guests
           @user_name = current_user.id
           @desc = @servicelisting.description
           @barowner_email = @servicelisting.email
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
         end 
      else 
        p settlement_result.errors
        flash[:error] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction.  Re-enter your credit card details"
        redirect_to root_path
      end
    elsif result.transaction
      puts "Error processing transaction:"
      puts "  code: #{result.transaction.processor_response_code}"
      puts "  text: #{result.transaction.processor_response_text}"
    else
      p result.errors
    end
    
    
    
   # if params[:complete_authorization]      
     # @orders = Order.where("user_id = ? AND servicelisting_id = ? AND state = ? ", current_user.id, params[:order][:servicelisting_id], 'authorized')
     #      @orders.each do |order|
     #        order.express_token = params[:order][:express_token]
     #        order.express_payer_id = params[:order][:express_payer_id]
     #        @servicelisting = Servicelisting.find(params[:order][:servicelisting_id])
     #        if order.save
     #          if order.authorize_payment
     #            flash[:notice] = "You are authorized to bid on: #{@servicelisting.title}"
     #            redirect_to root_path
     #          else
     #            flash[:notice] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction. Re-enter your credit card details"
     #            #redirect_to new_user_credit_card_path(current_user)
     #            redirect_to root_path
     #          end
     #        end
     #     end  
      
  #  else
  #   ccard = current_user.credit_card
     # @order = Order.create(:amount => params[:order][:amount],
     #                            :first_name => "ccard.first_name",
     #                            :last_name => "ccard.last_name",
     #                            :card_type => "ccard.card_type",
     #                            :card_number => "ccard.card_number",
     #                            :card_verification => "ccard.card_verification",
     #                            :card_expires_on => "ccard.card_expires_on",
     #                            :address => "ccard.address",
     #                            :city => "ccard.city",
     #                            :state_name => "ccard.state_name",
     #                            :country => "ccard.country",
     #                            :zip => "ccard.zip"
     #                             )
     #     @order.servicelisting_id = params[:order][:servicelisting_id]
     #     @order.user_id = current_user.id
     #     @order.ip_address = request.remote_ip
     #     @order.description = "Buynow"
     #     @servicelisting = Servicelisting.find(@order.servicelisting_id)
     #     @product = @servicelisting.title
     #     @cost = @servicelisting.price
     #     @no_of_guests = @servicelisting.no_of_guests
     #     @user_name = current_user.id
     #     @desc = @servicelisting.description
     #     @barowner_email = @servicelisting.email
     #     #pp
     #     @order.express_token = params[:order][:express_token]
     #     @order.express_payer_id = params[:order][:express_payer_id]
     #     if @order.save
     #         if @order.purchase
     #           @servicelisting.winner_id = @order.user_id
     #           @servicelisting.status = "Closed"
     #           @servicelisting.availability = DateTime.now
     #           @servicelisting.save
     #           #all_biders = Bid.find(:all, :conditions => ["servicelisting_id=?",@order.servicelisting_id])
     #           all_biders = Bid.where("servicelisting_id=?",@order.servicelisting_id)
     #           all_biders.each do |bidder|
     #             logger.debug " #{bidder.user_id}"
     #             @user_details = User.where("id = ?", bidder.user_id).first
     #             bidder_email = @user_details.email
     #             Notifier.send_mail_to_each_bidder_after_buy(bidder_email,@product,@cost,@desc).deliver
     #           end
     #           # test code start
     #           Notifier.send_mail_to_user_after_buy(current_user.email,@product,@cost,@desc).deliver
     #           Notifier.send_mail_to_admin_after_buy(@product,@cost,@desc).deliver
     #           Notifier.send_mail_to_barowner_after_buy(@barowner_email,@product,@cost,@desc).deliver
     #           render :action => "success"
     #         else
     #           flash[:notice] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction.  Re-enter your credit card details"
     #          #redirect_to new_user_credit_card_path(current_user)
     #          redirect_to root_path
     #         end
   # end 
  end  
# def create
#    ccard = current_user.credit_card
#    @order = Order.create(:amount => params[:order][:amount],
#                          :first_name => ccard.first_name,
#                          :last_name => ccard.last_name,
#                          :card_type => ccard.card_type,
#                          :card_number => ccard.card_number,
#                          :card_verification => ccard.card_verification,
#                          :card_expires_on => ccard.card_expires_on,
#                          :address => ccard.address,
#                          :city => ccard.city,
#                          :state_name => ccard.state_name,
#                          :country => ccard.country,
#                          :zip => ccard.zip
#                           )
#   @order.servicelisting_id = params[:order][:servicelisting_id]
#   @order.user_id = current_user.id
#   @order.ip_address = request.remote_ip
#   @order.description = "Buynow"
#   @servicelisting = Servicelisting.find(@order.servicelisting_id)
#   @product = @servicelisting.title
#   @cost = @servicelisting.price
#   @no_of_guests = @servicelisting.no_of_guests
#   @user_name = current_user.id
#   @desc = @servicelisting.description
#   @barowner_email = @servicelisting.email
#   if @order.save
#       if @order.purchase
#         @servicelisting.winner_id = @order.user_id
#         @servicelisting.status = "Closed"
#         @servicelisting.availability = DateTime.now
#         @servicelisting.save
#         #all_biders = Bid.find(:all, :conditions => ["servicelisting_id=?",@order.servicelisting_id])
#         all_biders = Bid.where("servicelisting_id=?",@order.servicelisting_id)
#         all_biders.each do |bidder|
#           logger.debug " #{bidder.user_id}"
#           @user_details = User.where("id = ?", bidder.user_id).first
#           bidder_email = @user_details.email
#           Notifier.send_mail_to_each_bidder_after_buy(bidder_email,@product,@cost,@desc).deliver
#         end
#         # test code start
#         Notifier.send_mail_to_user_after_buy(current_user.email,@product,@cost,@desc).deliver
#         Notifier.send_mail_to_admin_after_buy(@product,@cost,@desc).deliver
#         Notifier.send_mail_to_barowner_after_buy(@barowner_email,@product,@cost,@desc).deliver
#         render :action => "success"
#       else
#         flash[:notice] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction.  Re-enter your credit card details"
#        #redirect_to new_user_credit_card_path(current_user)
#        redirect_to root_path
#       end
#   end 
# end
   
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