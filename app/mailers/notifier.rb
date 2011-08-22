class Notifier < ActionMailer::Base
  default :from => "prasanna548@gmail.com"
  
  def activation_instructions(user)    
    @account_activation_url = activate_url(user[:perishable_token])
    mail(:to => user[:email],
         :subject => "Activation Instructions - Social Cheers")
  end
  
  def welcome_email(user)
    @root_url = root_url
    @username = user.login
    @website = WEB_SITE
    mail(:to => user.email,
         :subject => "Welcome to Social Cheers")
  end
  
  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => user.email,
         :subject => "Password Reset Instructions") 
  end
  
  def bid_expired_email(user)
    mail(:to => user.email,
         :subject => "Bidding for service closed")
  end
  
  def invite_friend(all_email,msg_w,subject_w)
    mail(:to => all_email,
         :subject => subject_w,
         :body => msg_w)
  end
  
  def bar_onwer_confirmation_mail(email)
    mail(:to => email,
         :subject => "Welcome to SocialCheers")
  end
  
  def bar_onwer_confirmation_mail_to_admin
    mail(:to => 'nchinnareddy@gmail.com',
         :subject => "new bar owner registered",
         :body => "new bar owner registered")
  end
  
  def bar_onwer_confirmation_mail_bussiness_activated(email)
    @data = User.where("email=?", email).first
    @perishable_token =  @data.perishable_token
    @account_activation_url = activate_url(@perishable_token)
    #@username = email
    #@password = code
    mail(:to => email,
         :subject => "Congratulations - Social Cheers Bar Approval Notice")
  end
  
  def bar_onwer_confirmation_mail_bussiness_suspended(email)
    mail(:to => email,
         :subject => "Sorry",
         :body => "Sorry , Your bar bussiness had beed suspended for some time, We will gat back to you soon")
  end
  
end
