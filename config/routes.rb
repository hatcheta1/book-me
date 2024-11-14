Rails.application.routes.draw do
  root "users#index"
  
  devise_for :users
  
  resources :bookings
  resources :businesses
  resources :business_hours
  resources :services
end
