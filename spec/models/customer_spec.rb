require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_many(:orders).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }

  describe "validations" do
    before do
      create(:customer, email: "existing@example.com")
    end

    it "validates uniqueness of email" do
      should validate_uniqueness_of(:email).case_insensitive
    end

    it "is valid with valid attributes" do
      customer = build(:customer)
      expect(customer).to be_valid
    end

    it "is not valid without a name" do
      customer = build(:customer, name: nil)
      expect(customer).not_to be_valid
      expect(customer.errors.full_messages).to include("Name can't be blank")
    end

    it "is not valid without an email" do
      customer = build(:customer, email: nil)
      expect(customer).not_to be_valid
      expect(customer.errors.full_messages).to include("Email can't be blank")
    end

    it "is not valid with a duplicate email" do
      customer = build(:customer, email: "existing@example.com")
      expect(customer).not_to be_valid
      expect(customer.errors.full_messages).to include("Email has already been taken")
    end
  end
end
