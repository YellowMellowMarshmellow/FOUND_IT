Rails.application.routes.draw do
  get 'thank_you_notes/index'
  get 'notifications/index'
  get 'notifications/mark_as_read'

  resources :found_items do
    collection do
      get :my_reports
    end

    member do
      delete :delete_image
    end
  end

  resources :lost_items do
    collection do
      get :my_reports
    end
    resources :matches, only: [:show, :update, :index]
    member do
      delete :delete_image
    end
  end

  resources :notifications, only: [:index] do
    member do
      get :mark_as_read
    end
    collection do
      get :mark_all_as_read
    end
  end

  resources :matches, only: [:index]

  devise_for :users

  root "homepages#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "/create_report", to: "pages#create_report"
  post "/create_report", to: "pages#create_report"

  resource :profile, only: [:show]

  resources :users do
    resources :thank_you_notes, only: [:index, :new, :create]
  end
end
