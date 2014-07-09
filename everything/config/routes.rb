Everything::Application.routes.draw do
  root 'videos#index'

  devise_for :users

  resources :channels

  get '/search', to: 'search#index'

  get 'videos/random', to: 'videos#random'

  resources :videos

  resources :categories

  resources :series, controller: "categories", cat_type: "series"
end
