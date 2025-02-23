require 'rails_helper'

RSpec.describe Vendors::HomeController, type: :controller do
  let!(:customer) { create(:customer) }
  let!(:pizza) { create(:pizza_with_sizes) }
  let!(:inventory) { create(:inventory, item_type: 'topping') }
  let!(:side) { create(:inventory, item_type: 'side') }
  let!(:order) { create(:order_with_pizzas_and_sides, customer: customer) }
  let!(:order_pizza) { create(:order_pizza, order: order, pizza: pizza, crust: 'New hand tossed', size: 'regular', quantity: 1, price: 150) }
  let!(:order_pizza_topping) { create(:order_pizza_topping, order_pizza: order_pizza, inventory: inventory, quantity: 1, price: 20) }
  let!(:order_side) { create(:order_side, order: order, inventory: side, quantity: 1, price: 55) }

  before do
    session[:role] = 'vendor'
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it "fetches the list of pizzas" do
      get :index
      expect(assigns(:pizzas)).to include(pizza)
    end

    it "fetches the list of inventories" do
      get :index
      expect(assigns(:inventories)).to include(inventory)
    end

    it "fetches the list of orders" do
      get :index
      expect(assigns(:orders)).to include(order)
    end
  end
end
