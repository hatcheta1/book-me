Rails.application.routes.draw do
  root "users#index"
  
  devise_for :users
  
  resources :bookings
  resources :businesses
  resources :business_hours
  resources :services

  get "/businesses/:business_name/bookings", to: "bookings#index_for_business", as: :business_bookings
  get "/users/:username/bookings",to: "bookings#index_for_client", as: :client_bookings
end
