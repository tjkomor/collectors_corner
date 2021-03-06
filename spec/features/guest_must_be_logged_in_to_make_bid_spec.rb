require 'rails_helper'

RSpec.describe 'Guest', type: :feature do
  create_store
  create_category
  create_items
  create_user
  create_roles
  feature 'bids' do
    it 'before logging in gives an error' do
      user_one.roles.clear << Role.where(name: 'user').first
      visit root_path

      store.activate

      click_link "Video Games"

      within("#item_#{item_one.id}") do
        click_button "See Auction Details"
      end

      click_link_or_button "Bid!"

      expect(page).to have_content("Username")

      fill_in 'Username', with: 'rossedfort'
      fill_in 'Password', with: 'password'
      click_button "Login"

      expect(current_path).to eq("/dashboard")

      visit root_path

      click_link "Video Games"

      within("#item_#{item_one.id}") do
        click_button "See Auction Details"
      end

      click_link_or_button "Bid!"

      visit '/dashboard'

      expect(page).to have_content("#{item_one.name}")
    end
  end
end
