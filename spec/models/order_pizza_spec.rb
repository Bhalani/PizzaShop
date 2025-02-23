require 'rails_helper'

RSpec.describe OrderPizza, type: :model do
  let(:order) { create(:order_with_pizzas_and_sides) }
  let(:pizza) { create(:pizza_with_sizes) }
  let(:inventory) { create(:inventory, item_type: 'topping') }

  it 'is valid with valid attributes' do
    order_pizza = OrderPizza.new(
      order: order,
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
    )
    expect(order_pizza).to be_valid
  end

  it 'is not valid without a crust' do
    order_pizza = OrderPizza.new(crust: nil)
    expect(order_pizza).to_not be_valid
  end

  it 'is not valid without a size' do
    order_pizza = OrderPizza.new(size: nil)
    expect(order_pizza).to_not be_valid
  end

  it 'is not valid without a quantity' do
    order_pizza = OrderPizza.new(quantity: nil)
    expect(order_pizza).to_not be_valid
  end

  it 'is not valid with a non-numerical quantity' do
    order_pizza = OrderPizza.new(quantity: 'abc')
    expect(order_pizza).to_not be_valid
  end

  it 'is not valid with a negative quantity' do
    order_pizza = OrderPizza.new(quantity: -1)
    expect(order_pizza).to_not be_valid
  end

  it 'is not valid without a price' do
    order_pizza = OrderPizza.new(price: nil)
    expect(order_pizza).to_not be_valid
  end

  it 'is not valid with a non-numerical price' do
    order_pizza = OrderPizza.new(price: 'abc')
    expect(order_pizza).to_not be_valid
  end

  it 'is not valid with a negative price' do
    order_pizza = OrderPizza.new(price: -100)
    expect(order_pizza).to_not be_valid
  end
end
