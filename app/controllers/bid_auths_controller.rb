class BidAuthsController < ApplicationController
  
  def authorize
    @amount = 100
    @order = Order.new
    flash[:notice] = "You must be authorized to bid. You pay $#{@amount} to be authorized"
    render 'orders/checkoutcc'  
  end

end
