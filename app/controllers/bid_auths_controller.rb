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
    #flash[:notice] = "You account is not authorized yet. Please authorize your account to start bidding"
    render 'credit_cards/new'
  end

end
