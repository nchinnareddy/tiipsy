class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  serialize :params
  cattr_accessor :gateway
  cattr_accessor :xpressgateway
  
  class << self
    
  def authorize(amount, credit_card, options = { } ) 
    process('authorization', amount) do |gw|
    gw.authorize(amount, credit_card, options)
    end 
  end
 
  def capture(amount, authorization, options = {})
    process('capture', amount) do |gw|
    gw.capture(amount, authorization, options)
    end
  end

  def void(authorization, options = {})
    process('void') do |gw|
    gw.void(authorization, options)
    end
  end
  
 def purchase(amount_in_cents, credit_card, options = { })
    process('purchase', amount_in_cents) do |gw|
      gw.purchase(amount_in_cents, credit_card, options)
    end
 end
 
 def xpresspurchase(amount_in_cents, options= { })
   process('purchase', amount_in_cents, true) do |gw|
     gw.purchase(amount_in_cents, options)
   end
 end
    
private

  def process(action, amount = nil, xpress= false)
    result = OrderTransaction.new
    result.amount = amount
    result.action = action

   begin
       if xpress
         response = yield xpressgateway
      else
         response = yield gateway   
       end
      
      result.success = response.success?
      result.reference = response.authorization
      result.message  = response.message
      result.params  = response.params
      result.test = response.test?
      rescue ActiveMerchant::ActiveMerchantError => e
        result.success = false
        result.reference = nil
        result.message = e.message
        result.params  = {}
        result.test = gateway.test?
     end
    result
    
  end
  
  end
  
  end
  
