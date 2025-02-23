class Vendors::PizzasController < ApplicationController
  before_action :require_vendor
  before_action :set_pizza, only: [ :edit, :update, :destroy ]

  def new
    @pizza = Pizza.new
    @pizza.pizza_sizes.build
  end

  def create
    @pizza = Pizza.new(pizza_params)
    if @pizza.save
      flash[:notice] = "Pizza is successfully created. You can add suitable inventory for it."
      redirect_to vendors_home_path
    else
      render :new
    end
  end

  def update
    if @pizza.update(pizza_params)
      flash[:notice] = "Pizza \"#{@pizza.name}\" is successfully updated."
      redirect_to vendors_home_path
    else
      render :edit
    end
  end

  def destroy
    @pizza.destroy
    flash[:notice] = "Pizza is successfully deleted."
    redirect_to vendors_home_path
  end

  private

  def set_pizza
    @pizza = Pizza.find_by(id: params[:id])
    unless @pizza
      flash[:alert] = "Pizza not found."
      redirect_to vendors_home_path
    end
  end

  def pizza_params
    params.require(:pizza).permit(:name, :is_vegetarian, pizza_sizes_attributes: [ :id, :size, :price, :_destroy ])
  end
end
