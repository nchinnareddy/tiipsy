class BuynowController < ApplicationController
  
  before_filter :require_user
  before_filter :require_user_balance
  
  def buynow   
    @sl = Servicelisting.find(params[:id])
     
#  user = User.find(current_user.id)
#  current_user.topay =  @sl.buynow_price.to_f
#  user.update_attributes({:topay =>  @sl.buynow_price.to_f})
#  user.save(false)
#  user.save
end

def express
  @service = Servicelisting.find(params[:id])
  amount = @service.buynow_price
  amount = amount.to_i
  amount = amount * 100
  response = EXPRESS_GATEWAY.setup_purchase(amount,
    options = {
    :items => [
    {
      :name => @service.title,
      :quantity => "1",
      :description => @service.description,
      :amount => amount
     }],
    :ip                => request.remote_ip,
    :return_url        => url_for(:controller => 'buynow', :action => 'complete', :id => @service.id),
#   :return_url        => new_order_url,
    :cancel_return_url => servicelistings_url
   } )
  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
end

def complete

  @order = current_user.orders.new(:express_token => params[:token])
  @service = Servicelisting.find(params[:id])
  details_response = OrderTransaction.xpressgateway.details_for(params[:token])
  
     if !details_response.success?
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
    
  @order = Order.new
  render 'orders/checkoutcc'
 
end
  
end
