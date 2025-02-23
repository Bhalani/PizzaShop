require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:customer) { create(:customer) }
  let(:pizza) { create(:pizza_with_sizes) }
  let(:inventory) { create(:inventory, item_type: 'topping') }
  let(:side) { create(:inventory, item_type: 'side') }

  it { should belong_to(:customer) }
  it { should have_many(:order_pizzas).dependent(:destroy) }
  it { should have_many(:order_sides).dependent(:destroy) }

  it { should validate_numericality_of(:total_price) }

  it 'is valid with valid attributes' do
    order = Order.new(
      customer: customer,
      total_price: 100,
      order_pizzas_attributes: [
        {
          pizza: pizza,
          crust: 'New hand tossed',
          size: 'regular',
          quantity: 1,
          price: 150,
          order_pizza_toppings_attributes: [
            {
              inventory: inventory,
              quantity: 1,
              price: 20
            }
          ]
        }
      ],
      order_sides_attributes: [
        {
          inventory: side,
          quantity: 1,
          price: 55
        }
      ]
    )
    expect(order).to be_valid
  end

  it 'is not valid without a customer' do
    order = Order.new(customer: nil)
    expect(order).to_not be_valid
  end

  it 'is not valid without a total price' do
    order = Order.new(total_price: nil)
    expect(order).to_not be_valid
  end

  it 'is not valid with a non-numerical total price' do
    order = Order.new(total_price: 'abc')
    expect(order).to_not be_valid
  end

  it 'is not valid with a negative total price' do
    order = Order.new(total_price: -100)
    expect(order).to_not be_valid
  end

  it 'is not valid without at least one pizza' do
    order = Order.new(customer: customer, total_price: 100)
    expect(order).to_not be_valid
    expect(order.errors[:base]).to include('Order must have at least one item.')
  end

  it 'is not valid with invalid nested attributes' do
    order = Order.new(
      customer: customer,
      total_price: 100,
      order_pizzas_attributes: [
        {
          pizza: pizza,
          crust: nil,
          size: 'regular',
          quantity: 1,
          price: 150,
          order_pizza_toppings_attributes: [
            {
              inventory: inventory,
              quantity: 1,
              price: 20
            }
          ]
        }
      ]
    )
    expect(order).to_not be_valid
  end

  it 'is valid with at least one pizza' do
    order = Order.new(
      customer: customer,
      total_price: 100,
      order_pizzas_attributes: [
        {
          pizza: pizza,
          crust: 'New hand tossed',
          size: 'regular',
          quantity: 1,
          price: 150,
          order_pizza_toppings_attributes: [
            {
              inventory: inventory,
              quantity: 1,
              price: 20
            }
          ]
        }
      ]
    )
    expect(order).to be_valid
  end
end
