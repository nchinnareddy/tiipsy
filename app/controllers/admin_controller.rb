class AdminController < ApplicationController
  
  before_filter :require_admin
  
def index
    @users = User.all
    @bidfee = Admin.first
    if @bidfee == nil
    flash[:notice] = "BIDDING AUTHORIZATION AMOUNT IS NOT SET"
    end
end
  
def orderindex
   @orders = Order.all
 end
 
def newbidfee
   @bidfee = Admin.new
end
  
def create
   @bidfee = Admin.new(params[:admin])

      if @bidfee.save
       flash[:notice] = "Bidding authorization amount is set"
      end
    render 'admin/index'
end

def show
    @bidfee = Admin.first
     render @bidfee
end

def edit
    @bidfee = Admin.first
end
  
def update
    @bidfee = Admin.first

    @bidfee.update_attributes(params[:admin])
    render 'show'
end
  
  
  
end
