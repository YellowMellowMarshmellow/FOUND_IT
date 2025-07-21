Rails.application.routes.draw do
  get 'notifications/index'
  get 'notifications/mark_as_read'

  resources :found_items do
    collection do
      get :my_reports
    end
  end

  resources :lost_items do
    collection do
      get :my_reports
    end
  end

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end

  resources :matches, only: [:index, :update]

  devise_for :users

  root "homepages#index"

  #root to: "pages#home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
