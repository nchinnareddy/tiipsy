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
   @activate_bar_owner = BarBussiness.where('name=?', params[:bar_name]).first
   email = @activate_bar_owner.email
   @user = User.where('email=?', email).first
   @activate_bar_owner.status = 1
   @activate_bar_owner.password = @activate_bar_owner.new_random_password()
   @user.password = @activate_bar_owner.password
   @user.password_confirmation = @activate_bar_owner.password
   code = @activate_bar_owner.password 
   @activate_bar_owner.save
   @user.save!
   Notifier.bar_onwer_confirmation_mail_bussiness_activated(email,code).deliver
   redirect_to :action => 'report'
 end
 
 def suspend
   @suspend_bar_owner = BarBussiness.where('name=?', params[:bar_name]).first
   email = @suspend_bar_owner.email
   @suspend_bar_owner.status = 2
   @suspend_bar_owner.save
  activate_bar_ownerotifier.bar_onwer_confirmation_mail_bussiness_suspended(email).deliver
   redirect_to :action => 'report'
 end 
  
end
