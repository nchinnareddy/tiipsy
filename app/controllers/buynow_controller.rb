class BuynowController < ApplicationController
  
  before_filter :require_user
  before_filter :require_user_with_creditcard


def buynow
   @sl = Servicelisting.find(params[:id])
   #if @sl.status == 'active'
     @amount = @sl.price
     @serviceid = @sl.id
     #@highestbid  = @sl.highestbid
     #if @amount <= @highestbid
        #@new_cost = @highestbid + 1
        #@sl.price = @new_cost
        #@sl.save
     #else
      #  @new_cost = @amount
     #end
     @order = Order.new
     render 'confirm', :layout => false  
     #return
  # else
    #  flash[:notice] = "Service is inactive, you can not buy"
    #  redirect_to servicelistings_path   
   #end
    
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
  @serviceid = @service.id
  @order = Order.new
  render 'orders/checkoutcc' 
end
  
end
