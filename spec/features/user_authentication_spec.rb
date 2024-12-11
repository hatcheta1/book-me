require 'rails_helper'

RSpec.feature "User Authentication", type: :feature do
  scenario "User signs up, logs in, and logs out" do
    visit new_user_registration_path

    fill_in "Email", with: "john@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    fill_in "Username", with: "john"
    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
    fill_in "Time zone", with: "Central Time (US & Canada)"
    click_button "Sign up"

    expect(page).to have_text("Welcome! You have signed up successfully.")

    click_link "Sign out"

    visit new_user_session_path
    fill_in "Email", with: "john@example.com"
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_text("Signed in successfully.")
  end
end
