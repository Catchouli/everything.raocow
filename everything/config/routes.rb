Everything::Application.routes.draw do
  root 'videos#index'

  devise_for :users

  resources :channels

  resources :videos do
    collection do
      get 'random'
      get 'search'
    end
  end

  resources :categories do
#    collection do
#      get 'random'
#      get 'search'
#    end
  end

  resources :series, controller: "categories", cat_type: "series" do
    collection do
      get 'random'
      get 'search'
    end
  end

end
