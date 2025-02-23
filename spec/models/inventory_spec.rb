require 'rails_helper'

RSpec.describe Inventory, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price_per_piece) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:item_type) }
  it { should validate_numericality_of(:quantity).only_integer }
  it { should validate_numericality_of(:price_per_piece) }

  describe "validations" do
    it "is valid with valid attributes" do
      inventory = build(:inventory)
      expect(inventory).to be_valid
    end

    it "is not valid without a name" do
      inventory = build(:inventory, name: nil)
      expect(inventory).not_to be_valid
      expect(inventory.errors.full_messages).to include("Name can't be blank")
    end

    it "is not valid without a price_per_piece" do
      inventory = build(:inventory, price_per_piece: nil)
      expect(inventory).not_to be_valid
      expect(inventory.errors.full_messages).to include("Price per piece can't be blank")
    end

    it "is not valid without a quantity" do
      inventory = build(:inventory, quantity: nil)
      expect(inventory).not_to be_valid
      expect(inventory.errors.full_messages).to include("Quantity can't be blank")
    end

    it "is not valid without an item_type" do
      inventory = build(:inventory, item_type: nil)
      expect(inventory).not_to be_valid
      expect(inventory.errors.full_messages).to include("Item type can't be blank")
    end

    it "is valid with a valid item_type" do
      %w[topping side crust].each do |valid_type|
        inventory = build(:inventory, item_type: valid_type)
        expect(inventory).to be_valid
      end
    end
  end
end
