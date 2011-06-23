class Order < ActiveRecord::Base
 has_many  :transactions, :class_name => 'OrderTransaction', :dependent => :destroy
  
  acts_as_state_machine :initial => :pending
  state :pending
  state :authorized
  state :paid
  state :payment_declined
  
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


def purchase(options= {})
  
  transaction do
       
       if express_token.blank?
         purchase_result = OrderTransaction.purchase(price_in_cents, credit_card, options)
       else
         purchase_result = OrderTransaction.xpresspurchase(price_in_cents, options)
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

private


def validate_card
  if express_token.blank? && !credit_card.valid?
    credit_card.errors.full_messages.each do |message|
      errors.add_to_base message
    end
  end
end

def authorize_payment(credit_card, options = {})
    options[:order_id] = number
     transaction do
      authorization = OrderTransaction.authorize(amount, credit_card, options)
      transactions.push(authorization)
     if authorization.success?
      payment_authorized!
     else
      transaction_declined!
     end
      authorization
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


def capture_payment(options = {})
    
  transaction do
    capture = OrderTransaction.capture(amount, authorization_reference, options)
    transactions.push(capture)
    if capture.success?
      payment_captured!
    else
      transaction_declined!
    end
      capture
    end
end
  
  def price_in_cents
    (amount*100).round
  end
  
  
  
      
end
