class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_pizzas, dependent: :destroy
  has_many :order_sides, dependent: :destroy
  accepts_nested_attributes_for :order_pizzas, allow_destroy: true
  accepts_nested_attributes_for :order_sides, allow_destroy: true

  validates :total_price, numericality: true
  validates :customer_id, presence: true
  validate :validate_order_items

  private

  def validate_order_items
    errors.add(:base, "Order must have at least one item.") if order_pizzas.empty? && order_sides.empty?

    order_pizzas.each do |order_pizza|
      validate_pizza_item(order_pizza)
    end
  end

  def validate_pizza_item(order_pizza)
    errors.add(:base, "Vegetarian pizza cannot have a non-vegetarian topping.") if vegetarian_pizza_with_non_veg_topping?(order_pizza)
    errors.add(:base, "Non-vegetarian pizza cannot have paneer topping.") if non_veg_pizza_with_paneer_topping?(order_pizza)
    errors.add(:base, "Non-vegetarian pizza cannot have more than one topping.") if non_veg_pizza_with_multiple_toppings?(order_pizza)
  end

  def vegetarian_pizza_with_non_veg_topping?(order_pizza)
    order_pizza.vegetarian_pizza_with_non_veg_topping?
  end

  def non_veg_pizza_with_paneer_topping?(order_pizza)
    order_pizza.non_veg_pizza_with_paneer_topping?
  end

  def non_veg_pizza_with_multiple_toppings?(order_pizza)
    order_pizza.non_veg_pizza_with_multiple_toppings?
  end
end
