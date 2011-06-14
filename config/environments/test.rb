Socialstock::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
  
  config.after_initialize do
     ActiveMerchant::Billing::Base.mode = :test
     OrderTransaction.gateway = ActiveMerchant::Billing::BogusGateway.new
  end
end

TWITTER_CONSUMER_KEY = "OlXjMoxkWUj2Fw5R5pjGDw"
TWITTER_CONSUMER_SECRET = "wc5uB2RO2OhV5hL5viCFfloLvpfr0zYwU7Ny9SaBhQ"

FACEBOOK_APP_ID = "175065049218161"
FACEBOOK_APP_SECRET = "d0b9733bbd3e85e9344216c3667cbae7"

LINKEDIN_API_KEY = "QVPHV28j1zTT5-pq3-G5lUkIJzT3CBcJoKLa0f7Vs19tgglvvyn6OjmaVPL1es2D"
LINKEDIN_SECRET_KEY = "KgeqVUL0Ov4iGxiYUX5QSH-mgjC7lGxzW1_UkGzE5X2gfvfM8FVssoIFzj4XH0h4"
