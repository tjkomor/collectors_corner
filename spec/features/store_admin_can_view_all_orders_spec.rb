require 'rails_helper'
RSpec.describe 'store admin', type: :feature do
  create_store
  create_category
  create_items
  create_store_admin
  create_roles
  create_user

  feature 'can view' do
    it 'all of the orders' do
      admin_one.roles << Role.where(name: 'store_admin')
      admin_one.stores.create(name: "Leons")
      visit login_path

      fill_in "Username", with: 'admin'
      fill_in "Password", with: 'admin'

      click_button "Login"


      click_link "View Past Orders"

      save_and_open_page
      expect(page).to have_content('190')
      expect(page).to have_content('5')
      expect(page).to have_content('Completed')
      within(".status_counts") do
        expect(page).to have_content('Completed 1')
        expect(page).to have_content('Out 1')
      end
    end

    xit 'can click on a link to view individual orders' do
      visit login_path

      fill_in "Username", with: 'admin'
      fill_in "Password", with: 'admin'

      click_button "Login"

      click_link rental_one.id

      expect(page).to have_link("70-200 Canon L")
      expect(page).to have_content("2")
      expect(page).to have_content("$120")
      expect(page).to have_content("Status: Completed")
    end
  end
end
