Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get '/index', to: 'categories#index'
  resources :videos, only: [:show]
  resources :categories, only: [:show]


end
