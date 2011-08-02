class BarBussinessesController < ApplicationController
  # GET /bar_bussinesses
  # GET /bar_bussinesses.xml
  def index
    @bar_bussinesses = BarBussiness.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bar_bussinesses }
    end
  end

  # GET /bar_bussinesses/1
  # GET /bar_bussinesses/1.xml
  def show
    @bar_bussiness = BarBussiness.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bar_bussiness }
    end
  end

  # GET /bar_bussinesses/new
  # GET /bar_bussinesses/new.xml
  def new
    @bar_bussiness = BarBussiness.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bar_bussiness }
    end
  end

  # GET /bar_bussinesses/1/edit
  def edit
    @bar_bussiness = BarBussiness.find(params[:id])
  end

  # POST /bar_bussinesses
  # POST /bar_bussinesses.xml
  def create
    @bar_bussiness = BarBussiness.new(params[:bar_bussiness])
    email=@bar_bussiness.email
    respond_to do |format|
      if @bar_bussiness.save
        format.html { redirect_to(@bar_bussiness, :notice => '') }
        format.xml  { render :xml => @bar_bussiness, :status => :created, :location => @bar_bussiness }
        Notifier.bar_onwer_confirmation_mail(email).deliver
        Notifier.bar_onwer_confirmation_mail_to_admin().deliver
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bar_bussiness.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bar_bussinesses/1
  # PUT /bar_bussinesses/1.xml
  def update
    @bar_bussiness = BarBussiness.find(params[:id])

    respond_to do |format|
      if @bar_bussiness.update_attributes(params[:bar_bussiness])
        format.html { redirect_to(@bar_bussiness, :notice => 'Bar bussiness was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bar_bussiness.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bar_bussinesses/1
  # DELETE /bar_bussinesses/1.xml
  def destroy
    @bar_bussiness = BarBussiness.find(params[:id])
    @bar_bussiness.destroy

    respond_to do |format|
      format.html { redirect_to(bar_bussinesses_url) }
      format.xml  { head :ok }
    end
  end
end
