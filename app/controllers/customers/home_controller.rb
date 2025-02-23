class Customers::HomeController < ApplicationController
  before_action :require_user

  def index
    @pizzas = Pizza.includes(:pizza_sizes).all
    @toppings = Inventory.where(item_type: "topping")
    @sides = Inventory.where(item_type: "side")
  end
end
