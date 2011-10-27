Socialstock::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  config.action_mailer.default_url_options = { :host => 'www.socialcheers.com', :port => 80}
  

  
  # config.after_initialize do
  #    ActiveMerchant::Billing::Base.mode = :test 
  # end
  # 
  # config.to_prepare do
  # OrderTransaction.gateway =  ActiveMerchant::Billing::PaypalGateway.new( 
  #   :login => 'nchinn_1309774589_biz_api1.gmail.com',
  #   :password => '1309774643',
  #   :signature => 'A4ZmaZtYP56ugAWbYNAcjqstyYtgAoBxWlcZnfA.iqDK4CgHeuwWpm12' )
  # 
  # OrderTransaction.xpressgateway =  ActiveMerchant::Billing::PaypalExpressGateway.new( 
  #   :login => 'nchinn_1307094132_biz_api1.gmail.com',
  #   :password => '1307094143',
  #   :signature => 'A3tSrUJhWQkOjSs.LnbMRFOlOFN3AdRRcOCmTIWXkXK8x5Pn4e93CiVB' )
  #   ::EXPRESS_GATEWAY = OrderTransaction.xpressgateway
  # end

  config.after_initialize do
      ActiveMerchant::Billing::Base.mode = :production 
   end 

config.to_prepare do
   paypal_options = {
     :login => "gashaw02_api1.yahoo.com",
     :password => "H5F6DNHE63S54WNZ",
     :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31A3iVwYD55DBbNgP13gSWebVQj.za"
   }  
   OrderTransaction.gateway =  ActiveMerchant::Billing::PaypalGateway.new(paypal_options)  
   OrderTransaction.xpressgateway =  ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
   ::STANDARD_GATEWAY = OrderTransaction.gateway
   ::EXPRESS_GATEWAY = OrderTransaction.xpressgateway
 end
 
 # config.to_prepare do
 #  OrderTransaction.gateway =  ActiveMerchant::Billing::PaypalGateway.new( 
 #    :login => 'gashaw02_api1.yahoo.com',
 #    :password => 'H5F6DNHE63S54WNZ',
 #    :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31A3iVwYD55DBbNgP13gSWebVQj.za' )
 #  
 #  OrderTransaction.xpressgateway =  ActiveMerchant::Billing::PaypalExpressGateway.new( 
 #    :login => 'gashaw02_api1.yahoo.com',
 #    :password => 'H5F6DNHE63S54WNZ',
 #    :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31A3iVwYD55DBbNgP13gSWebVQj.za' )
 #    ::EXPRESS_GATEWAY = OrderTransaction.xpressgateway
 #  end


end

WEB_SITE = "socialcheers.com"
TITLE = "Bid on bottles"

TWITTER_CONSUMER_KEY = "JuzjaQAFOI1ra50ZdSkg"
TWITTER_CONSUMER_SECRET = "LrC1raVj6Lk5E5DxbWCZR8yfpJiBptFWYzNVhCbg"

FACEBOOK_APP_ID = "262855740409040"
FACEBOOK_APP_SECRET = "caae85d27878869434207d1e643c18c3"

LINKEDIN_API_KEY = "pahe6oqxems2"
LINKEDIN_SECRET_KEY = "7BxL7M2qnJ9JxLmS"
