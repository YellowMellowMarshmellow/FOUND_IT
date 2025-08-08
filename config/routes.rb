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

  resource :profiles, only: [:show, :edit, :update]

  # ✅ Updated here
  resources :users, only: [:show, :edit, :update] do
    resources :thank_you_notes, only: [:index, :new, :create, :show]
  end

  root "homepages#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "/create_report", to: "pages#create_report"
  post "/create_report", to: "pages#create_report"

  # We updates profile to profiles so we can use avatar with cloudinary
  # resource :profile, only: [:show]
end
