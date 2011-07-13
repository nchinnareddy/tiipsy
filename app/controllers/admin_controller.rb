class AdminController < ApplicationController
  
  before_filter :require_admin
  
 def index
    @users = User.all
    render "admin/index"
 end
  
 def orderindex
   @orders = Order.all
   render "admin/orderindex"
 end
 
 def new_bidfee
   @bidfee = Admin.new
 end
 
  def create
    @bidfee = Admin.new(params[:admin])

    respond_to do |format|
      if @admin.save
        format.html { redirect_to(@admin, :notice => 'Admin was successfully created.') }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def create
    
    @servicelisting = Servicelisting.find(params[:servicelisting_id])
    @bid = @servicelisting.bids.new(params[:bid])
    @bid.user_id = current_user.id
    if @bid.bidprice > @servicelisting.highestbid
      @bid.save
      @servicelisting.highestbid = @bid.bidprice
      @servicelisting.save
    else
      flash[:notice] = "You must bid up. your bid failed"
    end
    
    redirect_to servicelistings_path
    
  end
 
 
 
end
