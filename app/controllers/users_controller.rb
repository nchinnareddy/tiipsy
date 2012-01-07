class UsersController < ApplicationController  
  before_filter :require_user, :only => [:show, :edit, :update] 
  skip_before_filter :require_user_with_mailid, :only => [:edit, :update]
  #ssl_required :account, :profile
  if ENV['RAILS_ENV'] == "development"
    #ssl_required :account, :profile
  else
    #ssl_required :account, :profile
  end
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
    
  end
  
  def create
    params[:user][:social_login] = false
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance
      flash[:notice] = "Signup Successful! Please check your email and follow instructions"      
      #User Activation code      
      @user.devliver_activation_instructions!
      user = {:email => @user.email, :perishable_token => @user.perishable_token}
      if ENV['RAILS_ENV'] == "development"        
        activation_mail = Notifier.activation_instructions(user).deliver
        logger.debug activation_mail
      elsif ENV['RAILS_ENV'] == "production"
        Notifier.activation_instructions(user).deliver      
      end
      redirect_to user_signup_path
    else
      render :action => :new
    end
  end
  
  def show
    @user = User.find(params[:id])   
  end

  def account_history
    @user = User.find(params[:id])
    @listings = Servicelisting.find(:all)
    
  end
  
  def edit
    @user = User.find(params[:id])
    @authorizations = current_user.authorization if current_user
  end
  
  def update
    @user = User.find(params[:id])    
    if !@user.social_login      
      if @user.update_attributes(params[:user])        
        flash[:notice] = "User details updated!"
        redirect_to user_path(@user.id)
      else
        render :action => :edit
      end
    else
      
      if @user.update_attributes(params[:user])  
        flash[:notice] = "User details updated!"
        redirect_to user_path(@user.id)
      else
        render :action => :edit
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  
  def change_password
    @user = User.find_by_id(current_user) 
  end
  
  def password_update
    @user = current_user    
        
    if @user.valid_password?(params[:old_password])
      if params[:password].length < 6
        flash[:error] = "New password should more then 6 characters"
        render :action => :change_password
      else
        if params[:password] != params[:password_confirmation]
          flash[:error] = "New password and confirm password should be same."
          render :action => :change_password
        else
          @user.password = params[:password]
          @user.password_confirmation = params[:password] 
          @user.save
          flash[:notice] = "Password changed successfully."          
          redirect_to user_path(current_user)
        end        
      end              
    else      
      flash[:error] = "Enter Correct password."
      render :action => :change_password
    end            
  end  
  
  def resend_activation
     render :layout=>false   
  end 
  
  def resent_activation
    @user = User.find_by_email(params[:email])
    if !@user.nil? 
      if @user.active?
        flash[:notice] = "Already Your account activated. Please Sign In."
        redirect_to root_path
      else
        #User Activation code
        @user.devliver_activation_instructions!
        user = {:email => @user.email, :perishable_token => @user.perishable_token}
        if ENV['RAILS_ENV'] == "development"
          activation_mail = Notifier.activation_instructions(user)
          logger.debug activation_mail
        elsif ENV['RAILS_ENV'] == "production"
          Notifier.activation_instructions(user).deliver      
        end
        
        flash[:notice] = "Activation mail sent, Please check your mail and follow instructions in that mail."
        redirect_to servicelistings_path        
      end      
    else
      flash[:error] = "We're sorry, but we could not locate your account."
      render :action => :resend_activation
    end
    
  end
  
  def profile
    @user_id = current_user.id
    @cedite_card_details = CreditCard.where("user_id=?",@user_id).first
  end
  
  def account
    @orders = Order.find(:all, :conditions => ["user_id = ? and state = ?", current_user.id, "paid"])
    @bids = Bid.find(:all, :conditions => ["user_id = ?", current_user.id])
  end
  
 def term_condition
   render :layout => false
 end
 
 def download
    send_file "#{RAILS_ROOT}/public/data/#{params[:file_name]}", :type=>"application/zip" 
 end
  
 def about_us
   
 end
 
 def how_it_works
   
 end
 
  def authorization_hold
    render :layout => false
  end
  
  def guest_list
    begin
      @order = Order.find(params[:order_id])
      @servicelisting = Servicelisting.find(@order.id)
      @guest_list = GuestList.where(:user_id => current_user.id, :product => @order.id)
    rescue
      flash[:notice] = "Order was not found"
      redirect_to account_users_path(:id => current_user.id)
    end
  end
  
end
