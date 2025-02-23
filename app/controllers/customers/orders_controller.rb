class Customers::OrdersController < ApplicationController
  before_action :require_user
  before_action :setup_order_form, only: [ :new, :create ]

  def new
    @order = Order.new
    @order.order_pizzas.build
    @order.order_pizzas.first.order_pizza_toppings.build
    @order.order_sides.build
  end

  def create
    @order = OrderCreator.new(order_params).call
    if @order.id.present?
      redirect_to customers_order_path(@order), notice: "Order was successfully created."
    else
      render_with_flash("Failed to place order.")
    end
  end

  def show
    @order = Order
      .includes(:customer, order_pizzas: [ :pizza, :order_pizza_toppings ], order_sides: [ :inventory ])
      .find(params[:id])
  end

  private

  def render_with_flash(message)
    flash[:alert] = message
    render :new, alert: "Failed to place order."
  end

  def setup_order_form
    @customers = Customer.all
    @pizzas = Pizza.all
    @toppings = Inventory.where(item_type: "topping")
    @crusts = Inventory.where(item_type: "crust")
    @sides = Inventory.where(item_type: "side")
  end

  def order_params
    params.require(:order).permit(:customer_id, order_pizzas_attributes: [
      :pizza_id, :crust, :size, :quantity, :price, order_pizza_toppings_attributes: [
        :inventory_id, :quantity, :price
      ]
    ], order_sides_attributes: [ :inventory_id, :quantity ])
  end
end
