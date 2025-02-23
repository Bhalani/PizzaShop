class Customers::PizzasController < ApplicationController
  before_action :require_user

  def index
    @pizzas = Pizza.includes(:pizza_sizes).all
  end

  def show
    @pizza = Pizza.find(params[:id])
  end
end
