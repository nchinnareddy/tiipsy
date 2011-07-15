class AdminController < ApplicationController
  
  before_filter :require_admin
  
def index
    @users = User.all
    @bidfee = Admin.find(1)
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
       flash[:notice] = "bidding fee was successfully created"
      end
    render 'admin/index'
end

def show
    @bidfee = Admin.find(1)
     render @bidfee
end

def edit
    @bidfee = Admin.find(1)
end
  
def update
    @bidfee = Admin.find(1)

    @bidfee.update_attributes(params[:admin])
    render 'show'
end
  
  
  
end
