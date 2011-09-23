class ContactsController < ApplicationController
  def new
    #raise params.to_yaml
     $no_of_guests = params[:no_of_guests]
     $user_name = params[:user_name]
     $product = params[:product]
    if ENV['RAILS_ENV'] == "development"
      redirect_to Google::Authorization.build_auth_url("http://localhost:3000/contacts/authorize")
    else
      redirect_to Google::Authorization.build_auth_url("http://socialcheers.com/contacts/authorize")
    end
  end
  
  def authorize
    token = Google::Authorization.exchange_singular_use_for_session_token(params[:token])
    raise token.inspect 

    unless token == false
      if ENV['RAILS_ENV'] == "development"
        redirect_to "http://localhost:3000/contacts?token=#{token}"
      else
        redirect_to "http://socialcheers.com/contacts?token=#{token}"  
      end 
    else
      flash[:error] = "Something went wrong while authorizing with google."
    end
  end
  
  def show
    @contacts = Google::Contact.all(params[:token])
  end
  
  def mail
    #raise params.to_yaml
    #raise @contacts = Contact.new(params[:contact]).inspect
    all_email = params[:contact_email]
    buyer_product = params[:buyer_product]
    buyer_user = params[:buyer_user]
    #raise all_name = params[:username].inspect
    #@total_email = all_email.length
    unless all_email
      render 'new'
    else
      msg_w = params[:msg]
      subject_w = params[:subject_w]
      #raise all_email.inspect
      Notifier.invite_friend(all_email,msg_w,subject_w).deliver
      #format.html { redirect_to(@user, :notice => 'Mail has delivered successfully.') }  
      #format.xml  { render :xml => @user, :status => :created, :location => @user }
      all_email.each do |email|
        @guestlist = GuestList.new
        @guestlist.email = email
        @guestlist.user_id = buyer_user
        @guestlist.product = buyer_product
        @guestlist.save
      end
      render 'send_mail'  
     end
 end 
 
    def destroy
      @guest = GuestList.find(params[:id])
      @guest.destroy
      redirect_to account_users_path
  end
  
  def update
    #raise params.to_yaml
    raise @guest = GuestList.find(params[:id]).inspect
  end
    
end
