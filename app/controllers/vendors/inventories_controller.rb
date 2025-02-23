class Vendors::InventoriesController < ApplicationController
  before_action :require_vendor
  before_action :set_inventory, only: [ :edit, :update, :destroy ]

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)
    if @inventory.save
      flash[:notice] = "Inventory is successfully created."
      redirect_to vendors_home_path
    else
      render :new
    end
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def update
    @inventory = Inventory.find(params[:id])
    if @inventory.update(inventory_params)
      flash[:notice] = "Inventory is successfully updated."
      redirect_to vendors_home_path
    else
      render :edit
    end
  end

  def destroy
    @inventory = Inventory.find(params[:id])
    @inventory.destroy
    flash[:notice] = "Inventory is successfully deleted."
    redirect_to vendors_home_path
  end

  private

  def set_inventory
    @inventory = Inventory.find_by(id: params[:id])
    unless @inventory
      flash[:alert] = "Inventory not found."
      redirect_to vendors_home_path
    end
  end

  def inventory_params
    params.require(:inventory).permit(:name, :category, :item_type, :price_per_piece, :quantity)
  end
end
