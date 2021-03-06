ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

include ActiveMerchant::Billing

def credit_card_hash(options = {})
{ :number => '1',
  :first_name => 'Cody',
  :last_name => 'Fauser',
  :month => '8',
  :year => "#{Time.now.year + 1 }" ,
  :verification_value => '123',
  :type => 'visa'
}.update(options)
end

def credit_card(options = {})
ActiveMerchant::Billing::CreditCard.new( credit_card_hash(options) )
end

def address(options = {})
  { :name => 'Cody Fauser',
    :address1 => 'Domalguda',
    :address2 => 'Indira park',
    :city => 'Hyderabad',
    :state => 'Andhra',
    :country => 'INDIA',
    :zip => '500011'
  }.update(options)
end

  # Add more helper methods to be used by all tests here...
end
