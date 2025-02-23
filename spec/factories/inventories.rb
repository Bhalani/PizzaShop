FactoryBot.define do
  factory :inventory do
    name { "Mushroom" }
    category { "veg" }
    item_type { "topping" }
    price_per_piece { 20 }
    quantity { 100 }

    factory :crust_inventory do
      name { "New hand tossed" }
      item_type { "crust" }
    end

    factory :side_inventory do
      name { "Cold drink" }
      item_type { "side" }
    end
  end
end
