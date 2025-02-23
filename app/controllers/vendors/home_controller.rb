class Vendors::HomeController < ApplicationController
  before_action :require_user
  before_action :require_vendor

  def index
    @orders = Order.includes(:customer, order_pizzas: [ :pizza, :order_pizza_toppings ], order_sides: [ :inventory ]).all
    @pizzas = Pizza.all
    @inventories = Inventory.all
  end
end
