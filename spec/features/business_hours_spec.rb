require 'rails_helper'

RSpec.feature 'Business hours', type: :feature do
  scenario 'Business owner can see default business hours after adding a business' do
    user = User.create!(email: 'john@example.com',
                        password: 'password',
                        password_confirmation: 'password',
                        username: 'john',
                        first_name: 'John',
                        last_name: 'Doe',
                        time_zone: 'Central Time (US & Canada)')

    login_as(user, scope: :user)

    visit edit_user_registration_path
    click_button "Add a business"
    fill_in 'Name', with: 'Test Business'
    fill_in 'Address', with: '123 Sample St'
    fill_in 'About', with: 'A sample business description'
    click_button 'Save'

    visit business_hours_path

    expect(page).to have_content('Monday: Closed')
    expect(page).to have_content('Tuesday: Closed')
    expect(page).to have_content('Wednesday: Closed')
    expect(page).to have_content('Thursday: Closed')
    expect(page).to have_content('Friday: Closed')
    expect(page).to have_content('Saturday: Closed')
    expect(page).to have_content('Sunday: Closed')
  end
end
