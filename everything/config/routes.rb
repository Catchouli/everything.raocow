Everything::Application.routes.draw do
  root 'static_pages#home'

  devise_for :users
  resources :channels
end
