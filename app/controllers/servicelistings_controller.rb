
class ServicelistingsController < ApplicationController
 before_filter :require_admin_barowner, :except => [:index, :show]
  
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

  def buynow
   @servicelisting = Servicelisting.find(params[:servicelisting_id])
      
  end

  # GET /servicelistings/1
  # GET /servicelistings/1.xml
  def show
    @servicelisting = Servicelisting.find(params[:id])

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
