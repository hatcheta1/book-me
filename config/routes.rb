Rails.application.routes.draw do
  resources :services
  resources :business_hours
  resources :businesses
  devise_for :users

  root "users#index"
end
