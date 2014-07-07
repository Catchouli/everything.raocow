Everything::Application.routes.draw do
  root 'static_pages#home'

  devise_for :users

  resources :channels

  resources :videos, except: [:index] do
    resources :categories, only: [:index]
  end

  resources :categories do
    resources :videos, only: [:index]
  end

  resources :series, controller: "categories", cat_type: "series" do
    resources :videos, only: [:index]
  end
end
