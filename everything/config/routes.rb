Everything::Application.routes.draw do
  root 'videos#index'

  devise_for :users

  resources :channels do
    member do
      get 'videos/random', channel_search: nil
    end
  end

  resources :videos do
    collection do
      get 'random'
      get 'search'
    end
  end

  resources :categories do
    collection do
      get 'random'
      get 'search'
    end
    member do
      get 'videos/random', category_search: nil
    end
  end

  resources :series, controller: "categories", cat_type: "series" do
    collection do
      get 'random'
      get 'search'
    end
    member do
      get 'videos/random', category_search: nil
    end
  end
end
