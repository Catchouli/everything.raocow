Everything::Application.routes.draw do
  root 'channels#index'

  devise_for :users
  resources :channels
end
