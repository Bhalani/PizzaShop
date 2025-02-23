FactoryBot.define do
  factory :order_pizza_topping do
    order_pizza
    inventory
    quantity { 1 }
    price { 20 }
  end
end
