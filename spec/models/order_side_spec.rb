require 'rails_helper'

RSpec.describe OrderSide, type: :model do
  let(:order) { create(:order_with_pizzas_and_sides) }
  let(:inventory) { create(:inventory, item_type: 'side') }

  it 'is valid with valid attributes' do
    order_side = OrderSide.new(
      order: order,
      inventory: inventory,
      quantity: 1,
      price: 55
    )
    expect(order_side).to be_valid
  end

  it 'is not valid without a quantity' do
    order_side = OrderSide.new(quantity: nil)
    expect(order_side).to_not be_valid
  end

  it 'is not valid with a non-numerical quantity' do
    order_side = OrderSide.new(quantity: 'abc')
    expect(order_side).to_not be_valid
  end

  it 'is not valid with a negative quantity' do
    order_side = OrderSide.new(quantity: -1)
    expect(order_side).to_not be_valid
  end

  it 'is not valid without a price' do
    order_side = OrderSide.new(price: nil)
    expect(order_side).to_not be_valid
  end

  it 'is not valid with a non-numerical price' do
    order_side = OrderSide.new(price: 'abc')
    expect(order_side).to_not be_valid
  end

  it 'is not valid with a negative price' do
    order_side = OrderSide.new(price: -100)
    expect(order_side).to_not be_valid
  end
end
