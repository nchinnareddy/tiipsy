class AdminController < ApplicationController
  before_filter :require_admin
  
  def index
    @users = User.all    
    render "admin/index"
  end
  
end
