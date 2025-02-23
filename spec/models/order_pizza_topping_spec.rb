require 'rails_helper'

RSpec.describe OrderPizzaTopping, type: :model do
  let(:order_pizza) { create(:order_pizza) }
  let(:inventory) { create(:inventory, item_type: 'topping') }

  it 'is valid with valid attributes' do
    order_pizza_topping = OrderPizzaTopping.new(
      order_pizza: order_pizza,
      inventory: inventory,
      quantity: 1,
      price: 20
    )
    expect(order_pizza_topping).to be_valid
  end

  it 'is not valid without a quantity' do
    order_pizza_topping = OrderPizzaTopping.new(quantity: nil)
    expect(order_pizza_topping).to_not be_valid
  end

  it 'is not valid with a non-numerical quantity' do
    order_pizza_topping = OrderPizzaTopping.new(quantity: 'abc')
    expect(order_pizza_topping).to_not be_valid
  end

  it 'is not valid with a negative quantity' do
    order_pizza_topping = OrderPizzaTopping.new(quantity: -1)
    expect(order_pizza_topping).to_not be_valid
  end

  it 'is not valid without a price' do
    order_pizza_topping = OrderPizzaTopping.new(price: nil)
    expect(order_pizza_topping).to_not be_valid
  end

  it 'is not valid with a non-numerical price' do
    order_pizza_topping = OrderPizzaTopping.new(price: 'abc')
    expect(order_pizza_topping).to_not be_valid
  end

  it 'is not valid with a negative price' do
    order_pizza_topping = OrderPizzaTopping.new(price: -100)
    expect(order_pizza_topping).to_not be_valid
  end
end
