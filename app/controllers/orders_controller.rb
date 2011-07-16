
class OrdersController < ApplicationController
  
def create
  @order = Order.create(params[:order])
  @order.amount = params[:order][:amount]
    
  if @order.express_token.blank?
        options = standard_purchase_options
   else 
        options = express_purchase_options
      end
  if @order.save
    if !credit_card.valid?
       render :action => "failure"
    else
      if @order.purchase(options)
        current_user.bid_authorized = true
        current_user.save
        current_user.create_credit_card(:card_type          => @order.card_type,
                                        :card_number        => @order.card_number,
                                        :card_verification  => @order.card_verification,
                                        :card_expires_on    => @order.card_expires_on,
                                        :first_name         => @order.first_name,
                                        :last_name          => @order.last_name,
                                        :address            => @order.address,
                                        :city               => @order.city,
                                        :state_name         => @order.state_name,
                                        :country            => @order.country,
                                        :zip                => @order.zip
                                        )              
        render :action => "success"
     else
      render :action => "failure"
    end
    end 
  else
    render :action => 'new'
  end
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

def express_purchase_options
  {
    :ip => request.remote_ip,
    :token => @order.express_token,
    :payer_id => @order.express_payer_id
  }
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