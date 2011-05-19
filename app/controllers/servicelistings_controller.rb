class ServicelistingsController < ApplicationController
  
  before_filter :require_admin, :except => [:index, :show]
  
    # GET /servicelistings
  # GET /servicelistings.xml
  def index
    @servicelistings = Servicelisting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @servicelistings }
    end
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

    respond_to do |format|
      if @servicelisting.save
        format.html { redirect_to(@servicelisting, :notice => 'Servicelisting was successfully created.') }
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

    respond_to do |format|
      format.html { redirect_to(servicelistings_url) }
      format.xml  { head :ok }
    end
  end

  
end
