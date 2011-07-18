class BidAuthsController < ApplicationController
  
  def authorize
    @authamount = Admin.first
    if @authamount != nil
    @amount = @authamount.bidding_fee
  else
    @amount = 500
   end

#   @order = Order.new
    @credit_card = CreditCard.new
    flash[:notice] = "You authorize your creditcard to bid. Please enter your creditcard details"
    render 'credit_cards/new'
  end

end
