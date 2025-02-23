FactoryBot.define do
  factory :pizza do
    name { "Sample Pizza" }
    is_vegetarian { true }

    factory :pizza_with_sizes do
      after(:build) do |pizza|
        pizza.pizza_sizes << build(:pizza_size, pizza: pizza, size: 'regular', price: 100)
        pizza.pizza_sizes << build(:pizza_size, pizza: pizza, size: 'medium', price: 200)
        pizza.pizza_sizes << build(:pizza_size, pizza: pizza, size: 'large', price: 300)
      end
    end
  end
end
