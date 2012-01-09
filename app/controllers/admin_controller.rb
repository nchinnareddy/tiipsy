class AdminController < ApplicationController
  
  before_filter :require_admin
  
def index
    @users = User.all
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
   #@activate_bar_owner.password = @activate_bar_owner.new_random_password()
   #@user.password = @activate_bar_owner.password
   #@user.password_confirmation = @activate_bar_owner.password
   @user.barowner = 1
   #code = @activate_bar_owner.password 
   @activate_bar_owner.save
   @user.save!
   Notifier.bar_onwer_confirmation_mail_bussiness_activated(email).deliver
   redirect_to :action => 'report'
 end
 
 def suspend
   @suspend_bar_owner = BarBussiness.where('name=?', params[:bar_name]).first
   email = @suspend_bar_owner.email
   @suspend_bar_owner.status = 2
   @suspend_bar_owner.save
   Notifier.bar_onwer_confirmation_mail_bussiness_suspended(email).deliver
   redirect_to :action => 'report'
 end 
 
 def listings
   if @city = params[:city]
      @servicelistings=Servicelisting.paginate :page=>params[:page], :per_page=>'2', :conditions => [ 'city=?', @city]
    else
      @location = Geokit::Geocoders::IpGeocoder.geocode(request.remote_ip)
      @city = @location.city
      #@city = 'agra'
      #@servicelistings=Servicelisting.search(params[:search]).paginate :page=>params[:page], :conditions => [ 'city=?', @city] , :order=>'updated_at', :per_page=>'3'
      @servicelistings=Servicelisting.paginate :page=>params[:page], :per_page=>'2', :conditions => [ 'city=?', @city]
    end
 end
 
 def list
   @servicelistings=Servicelisting.all
 end
 
 def margin_update
    @margin = params[:margin]
    @margin_type = params[:margin_type]
    @barbussiness = BarBussiness.find(params[:bar_bussiness_id])
    @barbussiness.margin = @margin
    @barbussiness.margin_type = @margin_type
    @barbussiness.save
    redirect_to list_bar_bussinesses_path
 end
 
 def bar_margin
    @bar_bussiness_id = params[:id]
    @bar_bussiness = BarBussiness.new
    render :layout =>false
 end

 def servicelistings_sales
   @orders = Order.paginate :page=>params[:page], :per_page=>'50'
 end

  def servicelisting_guests
    @guests = GuestList.where(:product => params[:order_id])
  end


  
end
