class Customers::OrderSidesController < ApplicationController
  before_action :require_user
  before_action :set_order

  def new
    @order_side = @order.order_sides.build
    @sides = Inventory.where(item_type: "side")
  end

  def create
    @order_side = @order.order_sides.build(order_side_params)
    if @order_side.save
      flash[:notice] = "Side added successfully."
      redirect_to customers_home_path
    else
      flash[:alert] = "Failed to add side."
      render :new
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def order_side_params
    params.require(:order_side).permit(:inventory_id, :quantity, :price)
  end
end
