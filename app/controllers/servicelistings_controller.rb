
class ServicelistingsController < ApplicationController
 before_filter :require_admin_barowner, :except => [:index, :show, :buynow, :new_authorization, :authorize]
  #ssl_required :authorize 
  
  if ENV['RAILS_ENV'] == "development"
    #ssl_required :authorize
  else
    ssl_required :authorize
  end
  
  def require_admin_barowner
   unless isadmin? || is_barowner?
        redirect_to root_path   
    end
  end
  
  def require_admin
   unless isadmin?
        redirect_to root_path   
    end
  end
  # GET /servicelistings
  # GET /servicelistings.xml
  def index
    @ts = 0
    @city = params[:city] || session[:city]
    unless @city
      @location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
      @city = @location.city
      @ts = 1
    end
    session[:city] = @city
    #@servicelistings=Servicelisting.search(params[:search]).paginate :page=>params[:page], :conditions => [ 'city=?', @city] , :order=>'updated_at', :per_page=>'3'
    @servicelistings=Servicelisting.paginate :page=>params[:page], :per_page=>'2', :conditions => [ 'city=?', @city], :order => 'availability DESC'
  end

  def buynow
   @servicelisting = Servicelisting.find(params[:servicelisting_id])      
  end
   
  def new_authorization
   @servicelisting = Servicelisting.find(params[:servicelisting_id])
   render :layout => false
  end
 
  def authorize
    @servicelisting = Servicelisting.find(params[:servicelisting_id])
     ccard = current_user.credit_card
     @order = Order.create(:first_name => ccard.first_name,
                           :last_name => ccard.last_name,
                           :card_type => ccard.card_type,
                           :card_number => ccard.card_number,
                           :card_verification => ccard.card_verification,
                           :card_expires_on => ccard.card_expires_on,
                           :address => ccard.address,
                           :city => ccard.city,
                           :state_name => ccard.state_name,
                           :country => ccard.country,
                           :zip => ccard.zip
                          )                          
  @order.amount = @servicelisting.price
  @order.servicelisting_id = @servicelisting.id
  @order.user_id = current_user.id
  @order.ip_address = request.remote_ip
  @order.description = "Authorization"

  if @order.save
      if @order.authorize_payment
        flash[:notice] = "You are authorized to bid on: #{@servicelisting.title}"
        redirect_to root_path
      else
        flash[:notice] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction. Re-enter your credit card details"
        redirect_to new_user_credit_card_path(current_user)
     end
  end   
end
  # GET /servicelistings/1
  # GET /servicelistings/1.xml
  def show
    @servicelisting = Servicelisting.find(params[:id])
    @servicelisting_id = @servicelisting.id
    #raise @total_active_bidder = Bid.find_by_sql("select distinct(user_id),servicelisting_id from bids where servicelisting_id = @servicelisting_id ").inspect
    #@total_active_bidder = Bid.find_by_sql("select distinct(user_id) from bids where servicelisting_id = servicelisting_id ").count
    @total_active_bidder = Bid.all(:select => "DISTINCT(user_id)", :conditions => ["servicelisting_id=?",@servicelisting_id]).count
    #raise @total_active_bidder = Bid.find(:user_id, :conditions => ["servicelisting_id=?",servicelisting_id]).count.inspect
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @servicelisting }
    end
  end

  # GET /servicelistings/new
  # GET /servicelistings/new.xml
  def new
    @servicelisting = Servicelisting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @servicelisting }
    end
  end

  # GET /servicelistings/1/edit
  def edit
    @servicelisting = Servicelisting.find(params[:id])
  end

  # POST /servicelistings
  # POST /servicelistings.xml
  def create
    @servicelisting = Servicelisting.new(params[:servicelisting])
    @bar_name = @servicelisting.bar_name
    @barbussiness = BarBussiness.find(:first, :conditions => ['name=?',@bar_name])
    @servicelisting.person_of_contact = @barbussiness.person_of_contact
    @servicelisting.email = @barbussiness.email
    @servicelisting.website = @barbussiness.website
    @servicelisting.location = @barbussiness.address
    @servicelisting.city = @barbussiness.city
    @servicelisting.phone = @barbussiness.phone
    @servicelisting.bar_name = @barbussiness.name
    
    respond_to do |format|
      if @servicelisting.save        
        format.html { redirect_to(@servicelisting, :notice => '') }
        format.xml  { render :xml => @servicelisting, :status => :created, :location => @servicelisting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @servicelisting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /servicelistings/1
  # PUT /servicelistings/1.xml
  def update
    @servicelisting = Servicelisting.find(params[:id])

    respond_to do |format|
      if @servicelisting.update_attributes(params[:servicelisting])
        format.html { redirect_to(@servicelisting, :notice => 'Servicelisting was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @servicelisting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /servicelistings/1
  # DELETE /servicelistings/1.xml
  def destroy
    @servicelisting = Servicelisting.find(params[:id])
    @servicelisting.destroy
    redirect_to :controller => "admin", :action => "list"
  end
  
end
