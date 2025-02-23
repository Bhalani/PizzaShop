FactoryBot.define do
  factory :order_pizza do
    order { create(:order_with_pizzas_and_sides) }
    pizza { create(:pizza_with_sizes) }
    crust { 'New hand tossed' }
    size { 'regular' }
    quantity { 1 }
    price { 150 }

    factory :order_pizza_with_toppings do
      transient do
        toppings_count { 1 }
      end

      after(:build) do |order_pizza, evaluator|
        order_pizza.order_pizza_toppings << create_list(:order_pizza_topping, evaluator.toppings_count, order_pizza: order_pizza)
      end
    end
  end
end
