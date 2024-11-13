Rails.application.routes.draw do
  root "users#index"

  devise_for :users

  resources :services, except: [:index]
  resources :business_hours
  resources :businesses
end
