Rails.application.routes.draw do
  root "users#index"

  devise_for :users

  resources :services
  resources :business_hours
  resources :businesses, except: [:index]
end
