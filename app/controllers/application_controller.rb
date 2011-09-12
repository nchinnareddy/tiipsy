class ApplicationController < ActionController::Base  
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user, :auth_provider, :isadmin?, :require_user_balance, :require_user_with_mailid, :is_barowner?
  before_filter :require_user_with_mailid
  include SslRequirement
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def isadmin?
    unless current_user
       return false
    end
    current_user.admin
  end
  
  def is_barowner?
    unless current_user
       return false
    end
    current_user.barowner
  end
  
  def auth_provider
    return @auth_provider if defined?(@auth_provider)
    @auth_provider = current_user.authorization
  end
    
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
    end
  end
  
def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_path
    end
end
  
def require_user_with_creditcard
  if current_user
    if !current_user.credit_card
      flash[:notice] = "You have not added your credit card details. Please enter your credit card details"
      redirect_to new_user_credit_card_path(current_user)
    end
  end
end

def require_service_bid_authorized
    if current_user
     authorders =  Order.where("user_id = ? AND servicelisting_id = ? AND state = ? ", current_user.id, params[:servicelisting_id], 'authorized')
     logger.debug authorders.to_yaml
        if authorders.empty?
          flash[:error] = "You are not authorized to bid on this service. Please authorize"
         redirect_to :controller => 'servicelistings', :action => 'new_authorization', :servicelisting_id => params[:servicelisting_id]
        end
     end

end

def require_admin
  unless isadmin?
    redirect_to root_path   
  end
end

    
def store_location
    session[:return_to] = request.request_uri
end
    
def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
end
  
def require_user_with_mailid    
    if current_user && current_user.email.nil?      
      flash[:error] = "You must update your email to access this page"
      redirect_to edit_user_path(current_user)
    end
end
end
