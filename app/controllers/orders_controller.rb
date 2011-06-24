
class OrdersController < ApplicationController
  
def create
  
  @order = current_user.orders.create(params[:order])
  @order.amount = current_user.pendingpay
  if @order.express_token.blank?
        options = standard_purchase_options
   else 
        options = express_purchase_options
      end
  if @order.save
    if !credit_card.valid?
       render :text => "card is not valid"
    else
      if @order.purchase(options )
      render :action => "success"
    else
      render :action => "failure"
    end
    end 
  else
    render :action => 'new'
  end
end

def express
  response = EXPRESS_GATEWAY.setup_purchase(20000,
    :ip                => request.remote_ip,
    :return_url        => new_order_url,
    :cancel_return_url => servicelistings_url,
    :customer         => current_user.login,
    :merchant         => "Tiipsy",
    :description      => "This is tiipsy order"
  )
  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
end

def new
  @order = current_user.orders.new(:express_token => params[:token])
  
  details_response = OrderTransaction.xpressgateway.details_for(params[:token])
  
     if !details_response.success?
      @message = details_response.message
      render :text => 'error'
      return
     end
    
    @address = details_response.address
  #  @amount = 111
    @amount = current_user.pendingpay
  
end


def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end


def standard_purchase_options
  {
    :ip => request.remote_ip,
    :billing_address => {
      :name     => "Ryan Bates",
      :address1 => "123 Main St.",
      :city     => "New York",
      :state    => "NY",
      :country  => "US",
      :zip      => "10001"
    }
  }
end

def express_purchase_options
  {
    :ip => request.remote_ip,
    :token => @order.express_token,
    :payer_id => @order.express_payer_id
  }
end


 def purchase_options
    {
      :ip => request.remote_ip,
      :billing_address => {
        :name     => "Chinna reddy",
        :address1 => "1st Main St.",
        :city     => "san jose",
        :state    => "CA",
        :country  => "US",
        :zip      => "95131"
      }
    }
end


 def credit_card
   
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => "Visa",
      :number             => "4871217555977030",
      :verification_value => "123",
      :month              => "6",
      :year               => "2016",
      :first_name         => "Chinna",
      :last_name          => "Nalimela"
    )

  end

end