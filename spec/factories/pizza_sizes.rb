FactoryBot.define do
  factory :pizza_size do
    size { "regular" }
    price { 100 }
    association :pizza
  end
end
