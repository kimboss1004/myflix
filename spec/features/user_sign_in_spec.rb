require 'spec_helper'

feature 'sign in' do
  scenario "with valid email and password" do
    kimboss = Fabricate(:user)
    visit login_path
    fill_in "email", with: kimboss.email
    fill_in "password", with: kimboss.password
    click_button "Sign in"
    expect(page).to have_content kimboss.full_name
  end
end