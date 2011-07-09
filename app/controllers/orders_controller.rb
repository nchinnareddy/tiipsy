
class OrdersController < ApplicationController
  
def create
  
  @order = Order.create(params[:order])
  @order.amount = params[:order][:amount]
 # cuser = current_user
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
        current_user.bid_authorized = true
        current_user.save
        render :action => "success"
     else
      render :action => "failure"
    end
    end 
  else
    render :action => 'new'
  end
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
      :name     => "Test User",
      :address1 => "1 Main St",
      :city     => "San Jose",
      :state    => "CA",
      :country  => "US",
      :zip      => "95131"
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
        :name     => "Test User",
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