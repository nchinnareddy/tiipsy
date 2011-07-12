class ContactsController < ApplicationController
  def new
    redirect_to Google::Authorization.build_auth_url("http://localhost:3000/contacts/authorize")
  end
  
  def authorize
    token = Google::Authorization.exchange_singular_use_for_session_token(params[:token])
    #raise token.inspect 

    unless token == false
      redirect_to "http://localhost:3000/contacts?token=#{token}"
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
