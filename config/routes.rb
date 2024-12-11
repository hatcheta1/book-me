Rails.application.routes.draw do
  root "home#redirect_root"

  devise_for :users
  
  resources :search, only: [:index]
  resources :home, only: [:index]
  get "/manifest.json", to: "pwa#manifest"

  # Bookings
  resources :bookings do
    member do
      patch :accept
      patch :decline
    end
  end
  get "/businesses/:business_name/bookings", to: "bookings#index_for_business", as: :business_bookings
  get "/users/:username/bookings",to: "bookings#index_for_client", as: :client_bookings

  # Businesses
  resources :businesses
  get "/businesses/:business_name/calendar", to: "businesses#calendar", as: :business_calendar

  resources :business_hours
  resources :services
end
