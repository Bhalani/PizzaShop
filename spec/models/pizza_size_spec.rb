require 'rails_helper'

RSpec.describe PizzaSize, type: :model do
  it { should belong_to(:pizza) }

  it "is valid with valid attributes" do
    pizza_size = build(:pizza_size)
    expect(pizza_size).to be_valid
  end

  it "is not valid without a size" do
    pizza_size = build(:pizza_size, size: nil)
    expect(pizza_size).not_to be_valid
    expect(pizza_size.errors.full_messages).to include("Size can't be blank")
  end

  it "is not valid without a price" do
    pizza_size = build(:pizza_size, price: nil)
    expect(pizza_size).not_to be_valid
    expect(pizza_size.errors.full_messages).to include("Price can't be blank")
  end
end
