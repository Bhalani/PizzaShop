require 'rails_helper'

RSpec.describe Customers::OrdersController, type: :controller do
  let(:customer) { create(:customer) }
  let(:pizza) { create(:pizza_with_sizes) }
  let(:non_veg_pizza) { create(:pizza_with_sizes, is_vegetarian: false) }
  let(:veg_topping) { create(:inventory, item_type: 'topping', category: 'veg', quantity: 10) }
  let(:non_veg_topping) { create(:inventory, item_type: 'topping', category: 'non_veg', quantity: 10) }
  let(:paneer_topping) { create(:inventory, item_type: 'topping', name: 'Paneer', category: 'veg', quantity: 10) }
  let(:crust) { create(:crust_inventory, item_type: 'crust', quantity: 10) }
  let(:side) { create(:side_inventory, item_type: 'side', quantity: 10) }

  let(:order_params) do
    {
      order: {
        customer_id: customer.id,
        order_pizzas_attributes: {
          "0" => {
            pizza_id: pizza.id,
            size: 'large',
            quantity: 1,
            crust: crust.name,
            order_pizza_toppings_attributes: {
              "0" => { inventory_id: veg_topping.id, quantity: 1 },
              "1" => { inventory_id: veg_topping.id, quantity: 1 }
            }
          }
        }
      }
    }
  end

  before do
    session[:role] = 'customer'
  end

  describe 'POST #create' do
    context 'when no params passed to order creation' do
      let(:params) { { order: { customer_id: customer.id } } }

      it 'returns validation message about what values are mandatory' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(assigns(:order).errors.full_messages).to include("Order must have at least one item.")
        expect(flash[:alert]).to eq("Failed to place order.")
      end
    end

    context 'when some correct value and some empty value passed' do
      let(:params) { { order: { customer_id: customer.id, order_pizzas_attributes: { "0" => { pizza_id: pizza.id } } } } }

      it 'returns validation message about what values are mandatory' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(assigns(:order).errors.full_messages).to include("An unexpected error occurred: Missing pizza parameters: crust, size, quantity")
        expect(flash[:alert]).to eq("Failed to place order.")
      end
    end

    context 'when the values are not right' do
      let(:params) do
        {
          order: {
            customer_id: customer.id,
            order_pizzas_attributes: {
              "0" => { pizza_id: pizza.id, size: 'large', quantity: 'abc', crust: crust.name }
            }
          }
        }
      end

      it 'returns validation message' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(assigns(:order).errors.full_messages).to include("Order pizzas quantity is not a number")
        expect(flash[:alert]).to eq("Failed to place order.")
      end
    end

    context 'when vegetarian pizza has a non-vegetarian topping' do
      let(:params) do
        {
          order: {
            customer_id: customer.id,
            order_pizzas_attributes: {
              "0" => {
                pizza_id: pizza.id,
                size: 'large',
                quantity: 1,
                crust: crust.name,
                order_pizza_toppings_attributes: {
                  "0" => { inventory_id: non_veg_topping.id, quantity: 1 }
                }
              }
            }
          }
        }
      end

      it 'returns appropriate error message' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(assigns(:order).errors.full_messages).to include("Vegetarian pizza cannot have a non-vegetarian topping.")
        expect(flash[:alert]).to eq("Failed to place order.")
      end
    end

    context 'when non-vegetarian pizza has paneer topping' do
      let(:params) do
        {
          order: {
            customer_id: customer.id,
            order_pizzas_attributes: {
              "0" => {
                pizza_id: non_veg_pizza.id,
                size: 'large',
                quantity: 1,
                crust: crust.name,
                order_pizza_toppings_attributes: {
                  "0" => { inventory_id: paneer_topping.id, quantity: 1 }
                }
              }
            }
          }
        }
      end

      it 'returns appropriate error message' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(assigns(:order).errors.full_messages).to include("Non-vegetarian pizza cannot have paneer topping.")
        expect(flash[:alert]).to eq("Failed to place order.")
      end
    end

    context 'when only one type of crust can be selected for any pizza' do
      let(:params) do
        {
          order: {
            customer_id: customer.id,
            order_pizzas_attributes: {
              "0" => { pizza_id: pizza.id, size: 'large', quantity: 1, crust: 'invalid_crust' }
            }
          }
        }
      end

      it 'returns appropriate error message' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(assigns(:order).errors.full_messages).to include("Inventory out of menu: invalid_crust")
        expect(flash[:alert]).to eq("Failed to place order.")
      end
    end

    context 'when only one of the non-veg toppings in non-vegetarian pizza' do
      let(:params) do
        {
          order: {
            customer_id: customer.id,
            order_pizzas_attributes: {
              "0" => {
                pizza_id: non_veg_pizza.id,
                size: 'large',
                quantity: 1,
                crust: crust.name,
                order_pizza_toppings_attributes: {
                  "0" => { inventory_id: non_veg_topping.id, quantity: 1 },
                  "1" => { inventory_id: non_veg_topping.id, quantity: 1 }
                }
              }
            }
          }
        }
      end

      it 'returns appropriate error message' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(assigns(:order).errors.full_messages).to include("Non-vegetarian pizza cannot have more than one topping.")
        expect(flash[:alert]).to eq("Failed to place order.")
      end
    end

    context 'when large size pizzas come with any 2 toppings of customers choice with no additional cost' do
      let(:params) { order_params }

      it 'adjusts price for two toppings' do
        post :create, params: params
        order = Order.last
        expect(response).to redirect_to(customers_order_path(order.id))
        order = Order.find(order.id)
        expect(order.total_price).to eq(pizza.pizza_sizes.find_by(size: 'large').price)
        expect(flash[:notice]).to eq("Order was successfully created.")
      end

      it 'adjusts price for more than two toppings' do
        params[:order][:order_pizzas_attributes]["0"][:order_pizza_toppings_attributes]["1"][:quantity] = 2
        post :create, params: params
        order = Order.last
        expect(response).to redirect_to(customers_order_path(order.id))
        order = Order.find(order.id)
        expect(order.total_price).to eq(pizza.pizza_sizes.find_by(size: 'large').price + veg_topping.price_per_piece)
        expect(flash[:notice]).to eq("Order was successfully created.")
      end
    end

    context 'when quantity is out of stock' do
      let(:params) do
        {
          order: {
            customer_id: customer.id,
            order_pizzas_attributes: {
              "0" => {
                pizza_id: pizza.id,
                size: 'large',
                quantity: 1,
                crust: crust.name,
                order_pizza_toppings_attributes: {
                "0" => { inventory_id: veg_topping.id, quantity: 1 }
                }
              }
            }
          }
        }
      end

      before do
        veg_topping.update(quantity: 0)
      end

      it 'returns appropriate error message' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(assigns(:order).errors.full_messages).to include("Insufficient quantity for #{veg_topping.name}")
        expect(flash[:alert]).to eq("Failed to place order.")
      end
    end

    context 'when order is successfully created' do
      let(:params) { order_params }

      it 'updates the inventory quantities' do
        expect {
          post :create, params: params
        }.to change { veg_topping.reload.quantity }.by(-2)
          .and change { crust.reload.quantity }.by(-1)
        expect(response).to redirect_to(customers_order_path(Order.last.id))
        expect(flash[:notice]).to eq("Order was successfully created.")
      end
    end
  end

  describe 'GET #show' do
    let(:order) { create(:order_with_pizzas_and_sides, customer: customer) }
    let!(:order_pizza) { create(:order_pizza, order: order, pizza: pizza) }
    let!(:order_side) { create(:order_side, order: order, inventory: side) }

    it 'loads the necessary order details' do
      get :show, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
      expect(assigns(:order).customer).to eq(customer)
      expect(assigns(:order).order_pizzas).to include(order_pizza)
      expect(assigns(:order).order_sides).to include(order_side)
    end
  end

  describe 'GET #new' do
    it 'loads the necessary records for order creation' do
      get :new
      expect(assigns(:customers)).to include(customer)
      expect(assigns(:pizzas)).to include(pizza)
      expect(assigns(:toppings)).to include(veg_topping, non_veg_topping)
      expect(assigns(:crusts)).to include(crust)
      expect(assigns(:sides)).to include(side)
    end
  end
end
