class BidAuthsController < ApplicationController
  
  def authorize
    @amount = 100
#   @order = Order.new
    @credit_card = CreditCard.new
    flash[:notice] = "You must have authorized creditcard to bid. Please enter your creditcard details"
    render 'credit_cards/new'
  end

end
