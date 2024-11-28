Rails.application.routes.draw do
  root "businesses#index"
  
  devise_for :users
  
  resources :bookings do
    member do
      patch :accept
      patch :decline
    end
  end

  resources :businesses
  resources :business_hours
  resources :services

  get "/businesses/:business_name/bookings", to: "bookings#index_for_business", as: :business_bookings
  get "/users/:username/bookings",to: "bookings#index_for_client", as: :client_bookings

  get "/businesses/:business_name/calendar", to: "businesses#calendar", as: :business_calendar
end
