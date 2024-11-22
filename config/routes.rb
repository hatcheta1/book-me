Rails.application.routes.draw do
  root "businesses#index"
  
  devise_for :users
  
  resources :bookings, except: :index
  resources :businesses
  resources :business_hours
  resources :services

  get "/businesses/:business_name/bookings", to: "bookings#index_for_business", as: :business_bookings
  get "/users/:username/bookings",to: "bookings#index_for_client", as: :client_bookings
end
