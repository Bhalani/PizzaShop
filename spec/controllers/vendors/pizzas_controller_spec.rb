require 'rails_helper'

RSpec.describe Vendors::PizzasController, type: :controller do
  let!(:pizza) { create(:pizza_with_sizes) }
  let!(:pizza_size) { create(:pizza_size, pizza: pizza, size: 'medium', price: 200) }

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
    it "creates a new Pizza" do
      expect {
        post :create, params: { pizza: { name: 'New Pizza', is_vegetarian: true, pizza_sizes_attributes: { '0' => { size: 'regular', price: 100 } } } }
      }.to change(Pizza, :count).by(1)
      expect(response).to redirect_to(vendors_home_path)
      expect(Pizza.last.pizza_sizes.first.size).to eq('regular')
      expect(Pizza.last.pizza_sizes.first.price).to eq(100)
    end

    it "does not create a new Pizza with invalid params" do
      post :create, params: { pizza: { name: '', is_vegetarian: true } }
      expect(response).to render_template(:new)
      expect(assigns(:pizza).errors.full_messages).to include("Name can't be blank", "Pizza sizes can't be blank")
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: pizza.id }
      expect(response).to be_successful
    end

    it "redirects to home with an alert for wrong ID" do
      get :edit, params: { id: 'wrong_id' }
      expect(response).to redirect_to(vendors_home_path)
      expect(flash[:alert]).to eq("Pizza not found.")
    end
  end

  describe "PATCH #update" do
    it "updates the requested pizza" do
      patch :update, params: { id: pizza.to_param, pizza: { name: 'Updated Pizza', is_vegetarian: false } }
      pizza.reload
      expect(pizza.name).to eq('Updated Pizza')
      expect(response).to redirect_to(vendors_home_path)
    end

    it "does not update the pizza with invalid params" do
      patch :update, params: { id: pizza.to_param, pizza: { name: '', is_vegetarian: false } }
      pizza.reload
      expect(pizza.name).not_to eq('')
      expect(response).to render_template(:edit)
      expect(assigns(:pizza).errors.full_messages).to include("Name can't be blank")
    end

    it "updates the pizza with nested pizza sizes" do
      patch :update, params: {
        id: pizza.id,
        pizza: {
          name: 'Updated Pizza',
          is_vegetarian: true,
          pizza_sizes_attributes: [
            { id: pizza_size.id, size: 'large', price: 300 }
          ]
        }
      }
      pizza.reload
      expect(pizza.name).to eq('Updated Pizza')
      expect(pizza.pizza_sizes.last.size).to eq('large')
      expect(pizza.pizza_sizes.last.price).to eq(300)
    end

    it "redirects to home with an alert for wrong ID" do
      patch :update, params: { id: 'wrong_id', pizza: { name: 'Updated Pizza', is_vegetarian: false } }
      expect(response).to redirect_to(vendors_home_path)
      expect(flash[:alert]).to eq("Pizza not found.")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested pizza" do
      pizza
      expect {
        delete :destroy, params: { id: pizza.to_param }
      }.to change(Pizza, :count).by(-1)
      expect(response).to redirect_to(vendors_home_path)
    end

    it "redirects to home with an alert for wrong ID" do
      delete :destroy, params: { id: 'wrong_id' }
      expect(response).to redirect_to(vendors_home_path)
      expect(flash[:alert]).to eq("Pizza not found.")
    end
  end
end
