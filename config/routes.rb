Rails.application.routes.draw do

  get 'users/edit'

  get 'users/update'

  root 'results/years#index'

  namespace :results do
    resources :categories, only: [:index, :show]
    resources :credits, only: :show
    resources :ballots, only: [:index, :show]
    resources :top_ten_entries, only: :index
    resources :scenes, only: [:index, :show]
    resources :years, only: :index
    resources :movies, only: [:index, :show] do
      get 'supplementary_ratings', on: :collection
    end
  end

  resources :users
  resources :ballots do
    get :edit_category_vote, on: :member
    get :new_category_vote, on: :member
    resources :build, controller: 'ballots/build'
    post :submit_ballot, on: :member
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :category_vote_groups, only: [:new, :create, :edit, :update] do
      get :autocomplete_vote_movie_id, on: :collection
    end
  resources :votes do
    get :admin_edit, on: :collection
    put :admin_update, on: :collection
  end
  resources :movies
  resources :category_vote_groups
  resources :ratings_groups
  resources :top_ten_lists

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'profile' => 'users#show'


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
