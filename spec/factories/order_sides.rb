FactoryBot.define do
  factory :order_side do
    order
    inventory
    quantity { 1 }
    price { 55 }
  end
end
