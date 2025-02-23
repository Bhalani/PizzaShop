require 'rails_helper'

RSpec.describe Pizza, type: :model do
  it { should have_many(:pizza_sizes).dependent(:destroy) }
  it { should accept_nested_attributes_for(:pizza_sizes).allow_destroy(true) }

  it { should validate_presence_of(:name) }
  it { should validate_inclusion_of(:is_vegetarian).in_array([ true, false ]) }
  it { should validate_presence_of(:pizza_sizes) }

  describe "default scope" do
    let!(:pizza) { create(:pizza_with_sizes) }

    it "includes pizza sizes" do
      expect(Pizza.all).to include(pizza)
      expect(Pizza.first.pizza_sizes).to be_present
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      pizza = build(:pizza_with_sizes)
      expect(pizza).to be_valid
    end

    it "is not valid without a name" do
      pizza = build(:pizza, name: nil)
      expect(pizza).not_to be_valid
      expect(pizza.errors.full_messages).to include("Name can't be blank")
    end

    it "is not valid without is_vegetarian" do
      pizza = build(:pizza, is_vegetarian: nil)
      expect(pizza).not_to be_valid
      expect(pizza.errors.full_messages).to include("Is vegetarian is not included in the list")
    end

    it "is not valid without pizza sizes" do
      pizza = build(:pizza)
      expect(pizza).not_to be_valid
      expect(pizza.errors.full_messages).to include("Pizza sizes can't be blank")
    end
  end

  describe "nested attributes" do
    it "rejects nested attributes if all blank" do
      pizza = build(:pizza, pizza_sizes_attributes: [ { size: '', price: '' } ])
      expect(pizza.pizza_sizes).to be_empty
    end
  end
end
