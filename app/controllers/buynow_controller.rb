class BuynowController < ApplicationController
  
  before_filter :require_user
    #change - pp start
 # before_filter :require_user_with_creditcard
   #change - pp end 
  #ssl_required :buynow, :express, :complete, :checkoutcc
  if ENV['RAILS_ENV'] == "development"
    #ssl_required :buynow, :express, :complete, :checkoutcc
  else
    #ssl_required :buynow, :express, :complete, :checkoutcc
  end

def buynow
   @sl = Servicelisting.find(params[:id])
   #if @sl.status == 'active'
     @amount = @sl.price
     @serviceid = @sl.id
     @highestbid  = @sl.highestbid
     if @amount <= @highestbid
        @new_cost = @highestbid + 1
        @sl.price = @new_cost
        @sl.buynow_price = @sl.price
        @sl.save
     else
        @new_cost = @amount
     end
     @order = Order.new
     render 'buynow', :layout => false  
     #return
  # else
    #  flash[:notice] = "Service is inactive, you can not buy"
    #  redirect_to servicelistings_path   
   #end
    
end

def express
  @service = Servicelisting.find(params[:id])
  amount = @service.price
  amount = amount.to_i
  amount = amount * 100

    #change - pp start
    options = {
       :items => [{ :name => @service.title,:quantity => 1, :description => @service.description, :amount => amount}],
        :ip                => request.remote_ip,
        :return_url        => url_for(:controller => 'buynow', :action => 'complete', :id => @service.id),
        :cancel_return_url => servicelistings_url
    } 
  response = EXPRESS_GATEWAY.setup_purchase(amount,options
       # :items => [{
       #   :name => @service.title,
       #   :quantity => 1,
       #   :description => @service.description,
       #   :amount => amount
       #  }],
      
    )
  
 #  response = EXPRESS_GATEWAY.setup_purchase(amount,
 #     options = {
 #     :items => [
 #     {
 #       :name => @service.title,
 #       :quantity => "1",
 #       :description => @service.description,
 #       :amount => amount
 #      }],
 #     :ip                => request.remote_ip,
 #     :return_url        => url_for(:controller => 'buynow', :action => 'complete', :id => @service.id),
 # #   :return_url        => new_order_url,
 #     :cancel_return_url => servicelistings_url
 #    } )
 
   #change - pp end 
  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
end

def complete
  @order = current_user.orders.new(:express_token => params[:token] , :express_payer_id => params[:PayerID])
  @service = Servicelisting.find(params[:id])
  #change - pp  start 
  details_response = OrderTransaction.xpressgateway.details_for(params[:token])
  #details_response = EXPRESS_GATEWAY.details_for(params[:token])
   #change - pp end 
 
     if details_response.success?
       @order = Order.create(:amount => @service.price,
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
                            :zip => "ccard.zip"
                             )
        @order.servicelisting_id = params[:id]
        @order.user_id = current_user.id
        @order.ip_address = request.remote_ip
        @order.description = "Buynow"
        @servicelisting = Servicelisting.find(@order.servicelisting_id)
        @product = @servicelisting.title
        @cost = @servicelisting.price
        @no_of_guests = @servicelisting.no_of_guests
        @user_name = current_user.id
        @desc = @servicelisting.description
        @barowner_email = @servicelisting.email
        @order.express_token = params[:token]
        @order.express_payer_id = params[:PayerID]
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
            #redirect_to new_user_credit_card_path(current_user)
            redirect_to root_path
          end
        end  
    else     
      @message = details_response.message
      render :text => 'error'
      return
    end  
  #  @address = details_response.address
  #  @amount = 111
  #  @amount = current_user.pendingpay
  #raise @order.to_yaml
  
end

def checkoutcc
  @service = Servicelisting.find(params[:id])
  @amount = @service.buynow_price
  @serviceid = @service.id
  @order = Order.new
  render 'orders/checkoutcc' 
end

def paypal_url(return_url)
  values = {
    :business => 'seller_1229899173_biz@railscasts.com',
    :cmd => '_cart',
    :upload => 1,
    :return => return_url,
    :invoice => id
  }
  line_items.each_with_index do |item, index|
    values.merge!({
      "amount_#{index+1}" => item.unit_price,
      "item_name_#{index+1}" => item.product.name,
      "item_number_#{index+1}" => item.id,
      "quantity_#{index+1}" => item.quantity
    })
  end
  "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
end


  
end
