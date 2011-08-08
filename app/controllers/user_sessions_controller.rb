class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  skip_before_filter :require_user_with_mailid
  
  def new
    @user_session = UserSession.new
    if current_user
      redirect_to user_path(current_user)
    end
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])    
    if @user_session.save      
      flash[:notice] = "Login successful!"
        if isadmin?
          redirect_to :controller => :admin, :action => :index
        elsif
          redirect_to :controller => :bar_bussinesses, :action => :index
        else
        redirect_back_or_default user_path(current_user)
        end
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    #redirect_back_or_default new_user_session_url
    redirect_to servicelistings_path
  end
  
end
