FactoryBot.define do
  factory :order do
    customer
    total_price { 100 }

    factory :order_with_pizzas_and_sides do
      transient do
        pizzas_count { 1 }
        sides_count { 1 }
      end

      after(:build) do |order, evaluator|
        order.order_pizzas << build_list(:order_pizza, evaluator.pizzas_count, order: order)
        order.order_sides << build_list(:order_side, evaluator.sides_count, order: order)
      end
    end
  end
end
