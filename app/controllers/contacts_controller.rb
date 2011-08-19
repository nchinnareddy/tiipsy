class ContactsController < ApplicationController
  def new
    if ENV['RAILS_ENV'] == "development"
      redirect_to Google::Authorization.build_auth_url("http://localhost:3000/contacts/authorize") 
    else
      redirect_to Google::Authorization.build_auth_url("http://173.255.195.108:8083/contacts/authorize") 
    end
  end
  
  def authorize
    token = Google::Authorization.exchange_singular_use_for_session_token(params[:token])
    #raise token.inspect 

    unless token == false
      if ENV['RAILS_ENV'] == "development"
        redirect_to "http://localhost:3000/contacts?token=#{token}"
      else
        redirect_to "http://173.255.195.108:8083/contacts?token=#{token}"
      end
    else
      flash[:error] = "Something went wrong while authorizing with google."
    end
  end
  
  def show
    @contacts = Google::Contact.all(params[:token])
  end
  
  def mail
    all_email = params[:contact_email]
    unless all_email
      render 'new'
    else
      msg_w = params[:msg]
      subject_w = params[:subject_w]
      #raise all_email.inspect
      Notifier.invite_friend(all_email,msg_w,subject_w).deliver
      #format.html { redirect_to(@user, :notice => 'Mail has delivered successfully.') }  
      #format.xml  { render :xml => @user, :status => :created, :location => @user }
      render 'send_mail'  
     end
   end  
   
    
end
