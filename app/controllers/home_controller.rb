class HomeController < ApplicationController
  def index
    @items = active_items[-3..-1]
    @featured_stores = stores
  end

  private

  def stores
    Store.all[0..2]
  end
end
