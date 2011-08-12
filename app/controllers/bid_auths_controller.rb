class BidAuthsController < ApplicationController
  
def authorize
    @authamount = Admin.first
    if @authamount != nil
    @amount = @authamount.bidding_fee
  else
    @amount = 100
   end
  end


end
