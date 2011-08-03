class AdminController < ApplicationController
  
  before_filter :require_admin
  
def index
    @users = User.all
    @bidfee = Admin.first
    if @bidfee == nil
    #flash[:notice] = "BIDDING AUTHORIZATION AMOUNT IS NOT SET"
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
  
 def report
   @active_bar_bussinesses = BarBussiness.find(:all, :conditions => [' status=?',1])
   @pending_bar_bussinesses = BarBussiness.find(:all, :conditions => [' status=?',0])
   @suspended_bar_bussinesses = BarBussiness.find(:all, :conditions => [' status=?',2])
 end
 
 def action
   render :layout=>false
 end
 
 def activate
   @aa = BarBussiness.where('name=?', params[:bar_name]).first
   @aa.status = 1
   @aa.save
   redirect_to :action => 'report'
 end
 
 def suspend
   @ss = BarBussiness.where('name=?', params[:bar_name]).first
   @ss.status = 2
   @ss.save
   redirect_to :action => 'report'
 end 
  
end
