class Notifier < ActionMailer::Base
  default :from => "prasanna548@gmail.com"
  
  def activation_instructions(user)    
    @account_activation_url = activate_url(user[:perishable_token])
    mail(:to => user[:email],
         :subject => "Activation Instructions #{WEB_SITE}")
  end
  
  def welcome_email(user)
    @root_url = root_url
    @username = user.login
    @website = WEB_SITE
    mail(:to => user.email,
         :subject => "Welcome to the site! #{WEB_SITE}")
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
         :subject => "Welcome to SocialCheers",
         :body => "we recieved your request and will process with in 24 hrs")
  end
  
  def bar_onwer_confirmation_mail_to_admin
    mail(:to => 'pravinmishra88@gmail.com',
         :subject => "new bar owner registered",
         :body => "new bar owner registered")
  end
  
  def bar_onwer_confirmation_mail_bussiness_activated(email,code)
    mail(:to => email,
         :subject => "Congratulation",
         :body => "Congratulation, Your bar bussiness had beed activared and Yr Username is #{ email} and password is #{ code}")
  end
  
  def bar_onwer_confirmation_mail_bussiness_suspended(email)
    mail(:to => email,
         :subject => "Sorry",
         :body => "Sorry , Your bar bussiness had beed suspended for some time, We will gat back to you soon")
  end
  
end
