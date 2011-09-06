Socialstock::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin 
  
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
   
  config.after_initialize do
     ActiveMerchant::Billing::Base.mode = :test
  end
 
  config.to_prepare do
  OrderTransaction.gateway =  ActiveMerchant::Billing::PaypalGateway.new( 
    :login => 'nchinn_1309774589_biz_api1.gmail.com',
    :password => '1309774643',
    :signature => 'A4ZmaZtYP56ugAWbYNAcjqstyYtgAoBxWlcZnfA.iqDK4CgHeuwWpm12' )
  
  OrderTransaction.xpressgateway =  ActiveMerchant::Billing::PaypalExpressGateway.new( 
    :login => 'nchinn_1307094132_biz_api1.gmail.com',
    :password => '1307094143',
    :signature => 'A3tSrUJhWQkOjSs.LnbMRFOlOFN3AdRRcOCmTIWXkXK8x5Pn4e93CiVB' )
    ::EXPRESS_GATEWAY = OrderTransaction.xpressgateway
  end

end

WEB_SITE = "localhost:3000"

TWITTER_CONSUMER_KEY = "OlXjMoxkWUj2Fw5R5pjGDw"
TWITTER_CONSUMER_SECRET = "wc5uB2RO2OhV5hL5viCFfloLvpfr0zYwU7Ny9SaBhQ"

FACEBOOK_APP_ID = "192100847492162"
FACEBOOK_APP_SECRET = "f500a4d0571ac03f41da2d64d65e25e6"

LINKEDIN_API_KEY = "QVPHV28j1zTT5-pq3-G5lUkIJzT3CBcJoKLa0f7Vs19tgglvvyn6OjmaVPL1es2D"
LINKEDIN_SECRET_KEY = "KgeqVUL0Ov4iGxiYUX5QSH-mgjC7lGxzW1_UkGzE5X2gfvfM8FVssoIFzj4XH0h4"

