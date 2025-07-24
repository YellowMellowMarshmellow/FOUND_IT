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
    resources :matches, only: [:show, :update, :index]
  end

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end

  resources :matches, only: [:index]

  devise_for :users

  root "homepages#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "/create_report", to: "pages#create_report"
  post "/create_report", to: "pages#create_report"
end
