Socialstock::Application.routes.draw do
  
  resources :albums

  resources :bar_bussinesses

  resources :locations

  resources :contacts
  
  get "contacts/mail"
  
  get "contacts/send_mail"
  
  match "/contacts/:id" => "contacts#mail"

  get "auth_linkedin/index"

  get "auth_linkedin/callback"
  
  get "credit_cards/term_condiation"

  resources :credit_cards

  resources :orders do
    collection do
    get 'success'
    get 'express'
    end
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match '/activate_account/:activation_code' => 'activations#create', :as => :activate
  
  get 'admin/index'
  get 'admin/report'
  get 'admin/action'
  get 'admin/activate'
  get 'admin/suspend'
  get 'admin/orderindex'
  get 'admin/newbidfee'
  post 'admin/create'
  put 'admin/update'
  get 'admin/edit'
#  match 'admin' => "admin#index"
#  match 'admin/:action' => 'admin#action'
#  get "admin/newbidfee"
  #match 'admin/delete' => "user/delete", :as => :remove

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :user_sessions
  resources :users do
    resources :bids
    collection do 
      get 'change_password'
      post 'password_update'
      get 'resend_activation'
      post 'resent_activation'
      get 'account_history'
    end
  end
  resources :password_resets, :only => [:new, :create, :edit, :update]

  resources :bid_auths do
    collection do
      get 'authorize'
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
 
  
  resources :servicelistings do      
  resources :bids, :new => { :express => :get }
end


  resources :friends do 
    collection do
      get 'get_facebook_friends'
      get 'get_facebook_status'
      get 'get_twitter_followers'
      post 'get_contacts'
    end
  end
  
  
  resources :authentications
  match '/auth/:provider/callback' => 'authorizations#create'
  match '/auth/failure' => 'authorizations#failure'

  
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  root :to => "servicelistings#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
