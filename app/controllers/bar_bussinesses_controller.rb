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
    @user = User.new
    email=@bar_bussiness.email
    @user.email = @bar_bussiness.email
    #@user.password = @bar_bussiness.password
    #@user.password_confirmation = @bar_bussiness.password_confirmation
    respond_to do |format|
      if @bar_bussiness.save
        @user.save(false)
        format.html { redirect_to(@bar_bussiness, :notice => '') }
        format.xml  { render :xml => @bar_bussiness, :status => :created, :location => @bar_bussiness }
        if ENV['RAILS_ENV'] == "development"
        activation_mail = Notifier.bar_onwer_confirmation_mail(email).deliver
          logger.debug activation_mail
        elsif ENV['RAILS_ENV'] == "production"
          Notifier.bar_onwer_confirmation_mail(email).deliver      
        end  
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
    @user_email = @bar_bussiness.email
    @user = User.first(:conditions => ["email=?", @user_email])
    @user.destroy
    @bar_bussiness.destroy
    redirect_to :controller => "admin", :action => "index"
  end
  
  #validate Unique Email
  def email_validate
    @user = User.where(:email => params[:email]).first    
  end
  
  def list
    if isadmin?
      @bar_bussinesses = BarBussiness.all
    else
      @bar_owner_email = current_user.email
      @bar_bussinesses = BarBussiness.find(:all, :conditions => ["email=?", @bar_owner_email])
    end 
    
  end

  def servicelist
    @servicelistings=Servicelisting.where("email=?", current_user.email)
  end
  
  def map
    @json = BarBussiness.find(:all, :conditions => [ 'city=?', params[:city] ]).to_gmaps4rails
    render :layout => 'location'
  end
  
end
