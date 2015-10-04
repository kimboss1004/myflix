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

  resources :users

  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

end
