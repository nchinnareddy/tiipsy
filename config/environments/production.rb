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
  
  config.action_mailer.default_url_options = { :host => '173.255.195.108', :port => 8083  }
  
  
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

WEB_SITE = "173.255.195.108"

TWITTER_CONSUMER_KEY = "4LNa1EYXgxu3ea2UYn0tw"
TWITTER_CONSUMER_SECRET = "uGWA8D3pipHkN3opHdbDVtT5H6L5SEy4gZRD5lRmjc"

FACEBOOK_APP_ID = "210381825645000"
FACEBOOK_APP_SECRET = "e52731a21459e73681b2579b91bc9dd8"

LINKEDIN_API_KEY = "VptWymcPtE4dpoq3AY_qVpvmlaO4xxljFkh9wIHzDedVMkr364EJMSRV6-9bN_wP"
LINKEDIN_SECRET_KEY = "WDoXYW-qdFgOEnLPp4i_S1pPBYiYf7ibYKxYCLXjaBmf7bSbLpY_yjV2NWg_mHTx"
