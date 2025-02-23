class OrderPizza < ApplicationRecord
  belongs_to :order
  belongs_to :pizza
  has_many :order_pizza_toppings, dependent: :destroy

  accepts_nested_attributes_for :order_pizza_toppings, allow_destroy: true

  enum :size, %i[regular medium large]

  validates :crust, presence: true
  validates :size, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  def vegetarian_pizza_with_non_veg_topping?
    pizza.is_vegetarian? && order_pizza_toppings.any?(&:non_veg?)
  end

  def non_veg_pizza_with_paneer_topping?
    !pizza.is_vegetarian? && order_pizza_toppings.any?(&:is_topping_paneer?)
  end

  def non_veg_pizza_with_multiple_toppings?
    !pizza.is_vegetarian? && order_pizza_toppings.size > 1
  end
end
