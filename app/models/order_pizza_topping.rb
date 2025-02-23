class OrderPizzaTopping < ApplicationRecord
  belongs_to :order_pizza
  belongs_to :inventory

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  def non_veg?
    inventory.non_veg?
  end

  def is_topping_paneer?
    inventory.name == "Paneer"
  end
end
