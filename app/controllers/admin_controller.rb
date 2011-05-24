class AdminController < ApplicationController
  
  before_filter :require_admin
  
  private
  
   def require_admin
   unless isadmin?
        redirect_to root_path   
    end
   end


  def index
    @users = User.all    
    render "admin/index"
  end
  
end
