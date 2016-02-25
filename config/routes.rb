Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => 'omniauth_callbacks' }

  get '/'     => 'home#index', :as => 'home'
  get '/bike' => 'home#bike',  :as => 'bike'
  get '/hike' => 'home#hike',  :as => 'hike'

  get  'adventure/new'        => 'adventure#new',    :as => 'new_adventure'
  get  'adventure/edit/:id'   => 'adventure#edit',   :as => 'edit_adventure'
  post 'adventure/create'     => 'adventure#create', :as => 'create_adventure'
  post 'adventure/update/:id' => 'adventure#update', :as => 'update_adventure'

  get  'about'            => 'position#index',  :as => 'position'
  get  'about/new'        => 'position#new',    :as => 'new_position'
  get  'about/edit/:id'   => 'position#edit',   :as => 'edit_position'
  post 'about/create'     => 'position#create', :as => 'create_position'
  post 'about/update/:id' => 'position#update', :as => 'update_position'

  get 'wall'         => 'wall#index', :as => 'wall'

  get  'actions'            => 'activity#index',  :as => 'activities'
  get  'actions/new'        => 'activity#new',    :as => 'new_activity'
  get  'actions/edit/:id'   => 'activity#edit',   :as => 'edit_activity'
  post 'actions/create'     => 'activity#create', :as => 'create_activity'
  post 'actions/update/:id' => 'activity#update', :as => 'update_activity'

  get  'users/'          => 'user#index',  :as => 'users'
  get  'user/new'        => 'user#new',    :as => 'new_user'
  get  'user/edit/:id'   => 'user#edit',   :as => 'edit_user'
  post 'user/create'     => 'user#create', :as => 'create_user'
  post 'user/update/:id' => 'user#update', :as => 'update_user'

  get 'logs/' => 'audit#index', :as => 'audit'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
