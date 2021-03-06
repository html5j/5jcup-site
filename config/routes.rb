Html5jcup::Application.routes.draw do

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :confirmations => 'users/confirmations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords',
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  resources :user_accounts, :only => [:index, :create, :destroy]


  mount Locomotive::Engine => '/locomotive', as: 'locomotive' # you can change the value of the path, by default set to "/locomotive"
  match "/dl/:slug" => "dl#show", :as => :Dl
  match "/accounts" => "accounts#show", :as => :Dl
  match "/accounts/edit_user" => "accounts#edit_user", :as => :user
  match "/accounts/update_user" => "accounts#update_user", :as => :user
  match "/accounts/delete_user" => "accounts#delete_user", :as => :user
  match "/accounts/show_works" => "accounts#show_works", :as => :work
  match "/accounts/edit_work" => "accounts#edit_work", :as => :work
  match "/accounts/show_work" => "accounts#show_work", :as => :work
  match "/accounts/update_work" => "accounts#update_work", :as => :work
  match "/accounts/delete_work" => "accounts#delete_work", :as => :work
  match "/accounts/download_works_csv" => "accounts#download_works_csv", :as => :download_works_csv, :default => {:format => :csv}
  match "/accounts/show_downloads" => "accounts#show_downloads", :as => :Dl
  match "/works/all" => "works#all"
  match "/users/deauth/:provider" => 'user_accounts#deauth'
  resources :works

  match "/award_accounts/login" => "award_accounts#login", :as => :Dl
  match "/award_accounts/show" => "award_accounts#show"
  match "/award_accounts/show_download" => "award_accounts#show_download"
  match "/award_accounts/logout" => "award_accounts#logout"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
