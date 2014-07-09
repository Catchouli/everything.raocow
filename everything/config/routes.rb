Everything::Application.routes.draw do
  root 'videos#index'

  devise_for :users

  resources :channels

  get 'videos/random', to: 'videos#random'

  resources :videos do
    resources :categories, only: [:index]
  end

  resources :categories do
    resources :videos, only: [:index]
  end

  resources :series, controller: "categories", cat_type: "series" do
    resources :videos, only: [:index]
  end
end
