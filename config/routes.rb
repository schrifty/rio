Rio::Application.routes.draw do
  devise_for :agents, :controllers => {registrations: 'registrations', sessions: 'sessions'}

  resources :invites, only: [:create, :destroy, :show, :index], :defaults => { :format => 'json' }
  resources :messages, only: [:create, :update, :show, :index ], :defaults => { :format => 'json' }
  resources :conversations, only: [:new, :create, :update, :show, :index], :defaults => { :format => 'json' } do
    collection do
      get :search, :defaults => { :format => 'html' }
    end
  end
  resources :agents, only: [:create, :destroy, :update, :show, :index, :current_agent], :defaults => { :format => 'json' }
  resources :customers, only: [:create, :update, :show, :index], :defaults => { :format => 'json' }
  resources :tenants, only: [:new, :create, :update, :show, :index], :defaults => { :format => 'json' }
  resources :updates, only: [:index], :defaults => { :format => 'json' }

  get '/current_agent' => 'agents#show_current_agent', :defaults => { :format => 'json' }

  root 'tenants#new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
