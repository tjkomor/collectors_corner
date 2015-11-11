ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require "database_cleaner"

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  def create_category
    let!(:category) { Category.create(name: 'Lenses') }
  end

  def create_brand
    let!(:brand) { Brand.create(name: 'Canon') }
  end

  def create_items
    let!(:item_one) { Item.create(name: '70-200 Canon L', description: "portrait lens", price: 12, brand_id: Brand.last.id, category_id: Category.last.id, image_url: 'http://www.bhphotovideo.com/images/images1000x1000/sony_sel1635z_vario_tessar_t_e_16_35mm_1082052.jpg') }
    let!(:item_two) { Item.create(name: '16-35 Canon L', description: "wide angle lens", price: 14, brand_id: Brand.last.id, category_id: Category.last.id, image_url: 'http://www.bhphotovideo.com/images/images1000x1000/sony_sel1635z_vario_tessar_t_e_16_35mm_1082052.jpg') }
  end

  def create_user
    let!(:user_one) { User.create(username: 'rossedfort', password: 'password') }
  end

  def create_rental
    let!(:rental_one) { Rental.create(user_id: User.last.id, days_rented: 5, total_price: 89, created_at: "2015-11-11 15:29:36") }
  end

  def create_rental_items
    RentalItem.create(rental_id: rental_one.id, item_id: item_one.id, quantity: 2)
    RentalItem.create(rental_id: rental_one.id, item_id: item_two.id, quantity: 1)
  end

  def add_item_to_cart
    visit items_path
    first(:button, "Add to Cart").click
  end

  def login_user
    visit login_path
    fill_in 'Username', with: 'rossedfort'
    fill_in 'Password', with: 'password'
    click_button "Login"
  end
end
