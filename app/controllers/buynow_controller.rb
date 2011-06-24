class BuynowController < ApplicationController
  
  before_filter :require_user
  before_filter :require_user_balance
  
  def buynow   
    @sl = Servicelisting.find(params[:id])
 #  current_user.topay =  @sl.buynow_price.to_f
    
    user = User.find(current_user.id)     
    user.update_attributes({:topay =>  @sl.buynow_price.to_f})
 #   user.save(false)
 #  user.save
  end
    
end
