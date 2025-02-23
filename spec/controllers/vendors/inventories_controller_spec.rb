require 'rails_helper'

RSpec.describe Vendors::InventoriesController, type: :controller do
  let(:inventory) { create(:inventory) }

  before do
    session[:role] = 'vendor'
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "creates a new Inventory" do
      expect {
        post :create, params: { inventory: { name: 'New Inventory', category: 'veg', item_type: 'topping', price_per_piece: 20, quantity: 100 } }
      }.to change(Inventory, :count).by(1)
      expect(response).to redirect_to(vendors_home_path)
    end

    it "does not create a new Inventory with invalid params" do
      post :create, params: { inventory: { name: '', category: 'veg', item_type: nil, price_per_piece: "test", quantity: "test" } }
      expect(response).to render_template(:new)
      expect(assigns(:inventory).errors.full_messages).to eq(
        [ "Name can't be blank", "Item type can't be blank",
          "Item type is not included in the list", "Quantity is not a number",
          "Price per piece is not a number" ])
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: inventory.to_param }
      expect(response).to be_successful
    end

    it "redirects to home with an alert for wrong ID" do
      get :edit, params: { id: 'wrong_id' }
      expect(response).to redirect_to(vendors_home_path)
      expect(flash[:alert]).to eq("Inventory not found.")
    end
  end

  describe "PATCH #update" do
    it "updates the requested inventory" do
      patch :update, params: { id: inventory.to_param, inventory: { name: 'Updated Inventory', category: 'non_veg', item_type: 'topping', price_per_piece: 25, quantity: 150 } }
      inventory.reload
      expect(inventory.name).to eq('Updated Inventory')
      expect(response).to redirect_to(vendors_home_path)
    end

    it "does not update the inventory with invalid params" do
      patch :update, params: { id: inventory.to_param, inventory: { name: '', category: 'non_veg', item_type: nil, price_per_piece: nil, quantity: 150 } }
      inventory.reload
      expect(inventory.name).not_to eq('')
      expect(response).to render_template(:edit)
      expect(assigns(:inventory).errors.full_messages).to eq(
        [ "Name can't be blank", "Price per piece can't be blank",
          "Item type can't be blank", "Item type is not included in the list",
          "Price per piece is not a number" ])
    end

    it "redirects to home with an alert for wrong ID" do
      patch :update, params: { id: 'wrong_id', inventory: { name: 'Updated Inventory', category: 'non_veg', item_type: 'topping', price_per_piece: 25, quantity: 150 } }
      expect(response).to redirect_to(vendors_home_path)
      expect(flash[:alert]).to eq("Inventory not found.")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested inventory" do
      inventory
      expect {
        delete :destroy, params: { id: inventory.to_param }
      }.to change(Inventory, :count).by(-1)
      expect(response).to redirect_to(vendors_home_path)
    end

    it "redirects to home with an alert for wrong ID" do
      delete :destroy, params: { id: 'wrong_id' }
      expect(response).to redirect_to(vendors_home_path)
      expect(flash[:alert]).to eq("Inventory not found.")
    end
  end
end
