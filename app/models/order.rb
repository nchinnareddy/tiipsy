class Order < ActiveRecord::Base
 has_many  :transactions, :class_name => 'OrderTransaction', :dependent => :destroy
 belongs_to :servicelisting
 belongs_to :user
  
  acts_as_state_machine :initial => :pending
  state :pending
  state :authorized
  state :paid
  state :payment_declined
  state :void
  
  event :payment_authorized do
    transitions :from => :pending,
                :to   => :authorized
    transitions :from => :payment_declined,
                :to   => :authorized
    end
    
  event :payment_captured do
    transitions :from => :authorized,
                :to   => :paid
    transitions :from => :pending,
                :to   => :paid            
    end
    
    event :payment_voided do
    transitions :from => :authorized,
                :to   => :void
    end
  
  event :payment_purchased do
     transitions :from => :pending,
                 :to   => :paid
  end
    
  event :transaction_declined do
    transitions :from => :pending,
                :to   => :payment_declined
    transitions :from => :payment_declined,
                :to   => :payment_declined
    transitions :from => :authorized,
                :to   => :authorized
  end


def authorize_payment
  #  options[:order_id] = number
     transaction do
      authorization = OrderTransaction.authorize(price_in_cents, credit_card, standard_purchase_options)
      transactions.push(authorization)
     if authorization.success?
      payment_authorized!
      return true
     else
      transaction_declined!
      return false
     end
      authorization
    end
end


def capture_payment
    
  transaction do
    capture = OrderTransaction.capture(price_in_cents, authorization_reference, standard_purchase_options)
    transactions.push(capture)
    if capture.success?
      payment_captured!
    else
      transaction_declined!
    end
      capture
    end
end

def void
   transaction do
    vooid = OrderTransaction.void(authorization_reference, standard_purchase_options)
    transactions.push(vooid)
    if vooid.success?
      payment_voided!
    else
      transaction_declined!
    end
      vooid
    end
end

def purchase

  logger.debug "PURCHASE IS INVOKED IN ORDER MODEL"
  transaction do
       
       if express_token.blank?
         purchase_result = OrderTransaction.purchase(price_in_cents, credit_card, standard_purchase_options)
       else
         purchase_result = OrderTransaction.xpresspurchase(price_in_cents, express_purchase_options)
       end
       transactions.push(purchase_result)
     if purchase_result.success?
       payment_captured!
      true
     else
       transaction_declined!
      false
     end 
    end
end

def express_token=(token)
  write_attribute(:express_token, token)
  if new_record? && !token.blank?
    details = EXPRESS_GATEWAY.details_for(token)
    self.express_payer_id = details.payer_id
  #  self.first_name = details.params["first_name"]
 #   self.last_name = details.params["last_name"]
  end
end


def validate_card
  if express_token.blank? && !credit_card.valid?
    credit_card.errors.full_messages.each do |message|
      errors.add_to_base message
    end
  end
end

def authorization_reference
  if authorization = transactions.find_by_action_and_success('authorization', true, :order => 'id ASC')
    authorization.reference
  end
end

def number
  "#{Time.now.to_i}-#{rand(1_000_000)}"
end
  
def standard_purchase_options
    {
        :ip => ip_address,
        :billing_address => {
        :name     => first_name + last_name,
        :address1 => address,
        :city     => city,
        :state    => state_name,
        :country  => country,
        :zip      => zip
       }
     }
end

def express_purchase_options
  {
    :ip => ip_address,
    :token => @order.express_token,
    :payer_id => @order.express_payer_id
  }
end
  
def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
end

def price_in_cents
   (amount * 100).round
end
  
end
