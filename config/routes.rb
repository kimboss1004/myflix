Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root   to: 'videos#root'
  
  resources :videos, only: [:show] do
    collection do
      get 'search'
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:index, :show]

  resources :users do
    member do
      post "/follow", to: 'relationships#create'
      delete "/unfollow", to: 'relationships#destroy'
      get '/people', to: 'users#people'
    end
  end

  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  resources :queue_items, only: [:index, :create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'


end
