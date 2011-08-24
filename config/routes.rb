Socialstock::Application.routes.draw do
   
  resources :contacts

  get "contacts/authorize"
  
  get "contacts/mail"
  
  get "contacts/send_mail"
   
  match "/contacts/:id" => "contacts#mail"

  get "auth_linkedin/index"

  get "auth_linkedin/callback"
  
  
  get 'admin/index'
  get 'admin/report'
  get 'admin/action'
  get 'admin/activate'
  get 'admin/suspend'
  get 'admin/orderindex'
  post 'admin/create'
  put 'admin/update'
  get 'admin/list'
  get 'admin/bar_margin'
  get 'admin/margin_update'
  
  match '/activate_account/:activation_code' => 'activations#create', :as => :activate
  
  match 'user/signup' => 'users#new', :as => "user_signup"
  
  match 'user/signin' => 'user_sessions#new', :as => "user_signin"
  
  match 'bar/register' => 'bar_bussinesses#new', :as => "bar_register"
 
  match '/auth/:provider/callback' => 'authorizations#create'
  
  match '/auth/failure' => 'authorizations#failure'

  resources :authentications
   
  resources :user_sessions
  
  resources :albums
  
  resources :locations
   
  resources :password_resets, :only => [:new, :create, :edit, :update]

  resources :users do
   collection do 
      get 'change_password'
      post 'password_update'
      get 'resend_activation'
      post 'resent_activation'
      get 'account_history'
      get 'profile'
      get 'account'
      get 'term_condition'
      get 'download'
      get 'about_us'
    end
   resources :credit_cards
   resources :bids
 end
 
   resources :servicelistings do
    get 'authorize'
    collection do
      get 'new_authorization'
     
   end   
   resources :bids, :new => { :express => :get }
  end
  
  resources :orders do
    collection do
    get 'success'
    get 'express'
    end
  end
  
   resources :bar_bussinesses do
    collection do
     get "list" 
     get "servicelist"
     get "email_validate"
     get "map"
    end
  end
  
  resources :buynow do
     collection do
       get 'buynow'
       get 'complete'
       get 'express'
       get 'checkoutcc'
     end
  end
 
  resources :friends do 
    collection do
      get 'get_facebook_friends'
      get 'get_facebook_status'
      get 'get_twitter_followers'
      post 'get_contacts'
    end
  end
   
  root :to => "servicelistings#index"

end
