class BidsController < ApplicationController
  
  before_filter :require_user
  before_filter :require_paypal_user
  
  # GET /bids
  # GET /bids.xml
  def index
    
    @servicelisting = Servicelisting.find(params[:servicelisting_id])
    
    @bids = @servicelisting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bids }
    end
  end

  # GET /bids/1
  # GET /bids/1.xml
  def show
    @bid = Bid.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bid }
    end
  end

  # GET /bids/new
  # GET /bids/new.xml
  def new
    
  @servicelisting = Servicelisting.find(params[:servicelisting_id])

 #   respond_to do |format|
 #     format.html # new.html.erb
  #    format.xml  { render :xml => @bid }
   # end
  end

  # GET /bids/1/edit
  def edit
    @bid = Bid.find(params[:id])
  end

  # POST /bids
  # POST /bids.xml
  def create
    
    @servicelisting = Servicelisting.find(params[:servicelisting_id])
    @bid = @servicelisting.bids.new(params[:bid])
    if @bid.bidprice > @servicelisting.highestbid
      @bid.save
      @servicelisting.highestbid = @bid.bidprice
      @servicelisting.save
    else
      flash[:notice] = "You must bid up. your bid failed"
    end
    
    redirect_to servicelistings_path
    
  end

  # PUT /bids/1
  # PUT /bids/1.xml
  def update
    @bid = Bid.find(params[:id])

    respond_to do |format|
      if @bid.update_attributes(params[:bid])
        format.html { redirect_to(@bid, :notice => 'Bid was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.xml
  def destroy
    @bid = Bid.find(params[:id])
    @bid.destroy

    respond_to do |format|
      format.html { redirect_to(bids_url) }
      format.xml  { head :ok }
    end
  end 
  
end
