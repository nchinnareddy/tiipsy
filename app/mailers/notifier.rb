class Notifier < ActionMailer::Base
  layout 'email'
  default :from => "info@socialcheers.com"
  
  def activation_instructions(user)
    @account_activation_url = activate_url(user[:perishable_token])
    mail(:to => user[:email],
         :subject => "Activation Instructions - Socialcheers")
  end
  
  def welcome_email(user)
    @root_url = root_url
    @username = user.login
    @website = WEB_SITE
    mail(:to => user.email,
         :subject => "Welcome to Socialcheers")
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
         :subject => "Welcome to Socialcheers ")
  end
  
  def bar_onwer_confirmation_mail_to_admin
    mail(:to => 'admin@socialcheers.com',
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
         :subject => "Congratulations - Socialcheers Bar Approval Notice")
  end
  
  def bar_onwer_confirmation_mail_bussiness_suspended(email)
    mail(:to => email,
         :subject => "Sorry - Socialcheers Bar Suspend Notice")
  end
  
  def send_mail_to_user_after_buy(email,product,cost,desc)
    @cost = cost
    @product = product
    @desc = desc
    mail(:to => email,
          :subject => "Your Purchase: Socialcheers - #{ product}")
  end
  
  def send_mail_to_each_bidder_after_buy(email,product,cost,desc)
    @cost = cost
    @product = product
    @desc = desc
    mail(:to => email,
          :subject => "Service bought: Socialcheers - #{ product}")
  end
  
  def send_mail_to_admin_after_buy(product,cost,desc)
    @cost = cost
    @product = product
    @desc = desc
    mail(:to => 'admin@socialcheers.com',
          :subject => "Service Sold: Socialcheers - #{ product}")
  end
  
  def send_mail_to_barowner_after_buy(barowner_email,product,cost,desc)
    @cost = cost
    @product = product
    @desc = desc
    mail(:to => barowner_email,
          :subject => "Service Sold: Socialcheers - #{ product}")
  end
  
  def send_mail_to_user_after_bid(email,bidprice,product,desc)
    @bidprice = bidprice
    @product = product
    @desc = desc
    mail(:to => email,
         :subject => "Your Bid: Socialcheers - #{ product}")
  end
  
  def send_mail_to_admin_after_bid(bidprice,product,desc)
    @bidprice = bidprice
    @product = product
    @desc = desc
    mail(:to => 'admin@socialcheers.com',
         :subject => "New Bid: Socialcheers - #{ product}")
  end
  
  def send_mail_to_barowner_after_bid(barowner_email,bidprice,product,desc) 
    @bidprice = bidprice
    @product = product
    @desc = desc
    mail(:to => barowner_email,
         :subject => "New Bid: Socialcheers - #{ product}")
  end
  
  def send_mail_to_user_outbid(email,outbid_price,bidprice,product,desc)
    @outbid_price = outbid_price
    @product = product
    @desc = desc
    @bidprice = bidprice
    mail(:to => email,
         :subject => "Your Bid: Socialcheers - #{ product} - someone outbid you.")
  end
  
  def send_mail_to_user_after_bid_closed(email,bidprice,product,desc)
    @bidprice = bidprice
    @product = product
    @desc = desc
    mail(:to => email,
         :subject => "Congratulations!!! You have won the Bid: Socialcheers - #{ product}")
  end 
  
  def send_mail_to_each_bidder_after_bid_closed(email,bidprice,product,desc)
    @bidprice = bidprice
    @product = product
    @desc = desc
    mail(:to => email,
         :subject => "Bid closed: Socialcheers - #{ product}")
  end
  
  def send_mail_to_barowner_after_bid_closed(email,bidprice,product,desc)
    @bidprice = bidprice
    @product = product
    @desc = desc
    mail(:to => email,
         :subject => "Congratulations!!! Bottle Service Sold: Socialcheers - #{ product}")
  end
  
end
