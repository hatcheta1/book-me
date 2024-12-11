# spec/features/booking_creation_spec.rb

require 'rails_helper'

RSpec.feature "Booking Creation", type: :feature do
  let(:user) do
    user = User.create!(email: 'john@example.com', 
                        password: 'password', 
                        password_confirmation: 'password',
                        username: 'john',
                        first_name: 'John',
                        last_name: 'Doe',
                        time_zone: 'Central Time (US & Canada)')
  end

  let(:business) do
    Business.create!(name: "Ashanti Styles", address: "200 S Wacker, Chicago, IL")
  end

  let(:service) do
    Service.create!(business: business, name: "Haircut", duration: 120, price: 75)
  end

  let(:booking) do
    Booking.create!(start_time: 1.week.from_now, client_name: "John Doe", business: business, service: service)
  end

  before do
    login_as(user, scope: :user)
  end

  scenario "User books an appointment at a business" do
    visit businesses_path

    click_link "Book an appointment at Ashanti Styles"

    click_button "Book"

    booking_date = 1.week.from_now.to_date
    booking_start_time = "#{booking_date} 08:00"

    fill_in "Start time", with: booking_start_time
    click_button "Create Booking"

    expect(page).to have_text("Booking was successfully created.")
    expect(Booking.last.start_time.to_s).to eq(booking_start_time)
    expect(Booking.last.client_name).to eq("John Doe")
  end
end
