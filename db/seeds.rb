# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
OrderSide.destroy_all
OrderPizzaTopping.destroy_all
OrderPizza.destroy_all
Order.destroy_all
Inventory.destroy_all
PizzaSize.destroy_all
Pizza.destroy_all
Customer.destroy_all

# Create sample inventories (extra toppings, sides, and crusts)
Inventory.create!(name: 'Black olive', category: 'veg', item_type: 'topping', price_per_piece: 20, quantity: 100)
Inventory.create!(name: 'Capsicum', category: 'veg', item_type: 'topping', price_per_piece: 25, quantity: 100)
Inventory.create!(name: 'Paneer', category: 'veg', item_type: 'topping', price_per_piece: 35, quantity: 100)
Inventory.create!(name: 'Mushroom', category: 'veg', item_type: 'topping', price_per_piece: 30, quantity: 100)
Inventory.create!(name: 'Fresh tomato', category: 'veg', item_type: 'topping', price_per_piece: 10, quantity: 100)
Inventory.create!(name: 'Chicken tikka', category: 'non_veg', item_type: 'topping', price_per_piece: 35, quantity: 100)
Inventory.create!(name: 'Barbeque chicken', category: 'non_veg', item_type: 'topping', price_per_piece: 45, quantity: 100)
Inventory.create!(name: 'Grilled chicken', category: 'non_veg', item_type: 'topping', price_per_piece: 40, quantity: 100)
Inventory.create!(name: 'Extra cheese', category: nil, item_type: 'topping', price_per_piece: 35, quantity: 100)
Inventory.create!(name: 'Cold drink', category: nil, item_type: 'side', price_per_piece: 55, quantity: 100)
Inventory.create!(name: 'Mousse cake', category: nil, item_type: 'side', price_per_piece: 90, quantity: 100)
Inventory.create!(name: 'New hand tossed', category: nil, item_type: 'crust', price_per_piece: 0, quantity: 100)
Inventory.create!(name: 'Wheat thin crust', category: nil, item_type: 'crust', price_per_piece: 0, quantity: 100)
Inventory.create!(name: 'Cheese Burst', category: nil, item_type: 'crust', price_per_piece: 0, quantity: 100)
Inventory.create!(name: 'Fresh pan pizza', category: nil, item_type: 'crust', price_per_piece: 0, quantity: 100)

# Create sample pizzas with sizes
pizza1 = Pizza.create!(name: 'Deluxe Veggie', is_vegetarian: true, pizza_sizes_attributes: [
  { size: 'regular', price: 150 },
  { size: 'medium', price: 200 },
  { size: 'large', price: 325 }
])
pizza2 = Pizza.create!(name: 'Cheese and Corn', is_vegetarian: true, pizza_sizes_attributes: [
  { size: 'regular', price: 175 },
  { size: 'medium', price: 375 },
  { size: 'large', price: 475 }
])
pizza3 = Pizza.create!(name: 'Paneer Tikka', is_vegetarian: true, pizza_sizes_attributes: [
  { size: 'regular', price: 160 },
  { size: 'medium', price: 290 },
  { size: 'large', price: 340 }
])
pizza4 = Pizza.create!(name: 'Non-Veg Supreme', is_vegetarian: false, pizza_sizes_attributes: [
  { size: 'regular', price: 190 },
  { size: 'medium', price: 325 },
  { size: 'large', price: 425 }
])
pizza5 = Pizza.create!(name: 'Chicken Tikka', is_vegetarian: false, pizza_sizes_attributes: [
  { size: 'regular', price: 210 },
  { size: 'medium', price: 370 },
  { size: 'large', price: 500 }
])
pizza6 = Pizza.create!(name: 'Pepper Barbecue Chicken', is_vegetarian: false, pizza_sizes_attributes: [
  { size: 'regular', price: 220 },
  { size: 'medium', price: 380 },
  { size: 'large', price: 525 }
])

# Create sample customers
customer1 = Customer.create!(name: 'John Doe', email: 'john@example.com')
customer2 = Customer.create!(name: 'Jane Smith', email: 'jane@example.com')
customer3 = Customer.create!(name: 'Alice Johnson', email: 'alice@example.com')
customer4 = Customer.create!(name: 'Bob Brown', email: 'bob@example.com')

# Create sample orders with nested attributes
order1_pizza_price = pizza1.pizza_sizes.find_by(size: 'regular').price * 2
order1_topping_price = Inventory.find_by(name: 'Black olive').price_per_piece * 1
order1_side_price = Inventory.find_by(name: 'Cold drink').price_per_piece * 2
order1_total_price = order1_pizza_price + order1_topping_price + order1_side_price

order1 = Order.create!(
  customer: customer1,
  total_price: order1_total_price,
  order_pizzas_attributes: [
    {
      pizza: pizza1,
      crust: 'New hand tossed',
      size: 'regular',
      quantity: 2,
      price: pizza1.pizza_sizes.find_by(size: 'regular').price,
      order_pizza_toppings_attributes: [
        {
          inventory: Inventory.find_by(name: 'Black olive'),
          quantity: 1,
          price: Inventory.find_by(name: 'Black olive').price_per_piece
        }
      ]
    }
  ],
  order_sides_attributes: [
    {
      inventory: Inventory.find_by(name: 'Cold drink'),
      quantity: 2,
      price: Inventory.find_by(name: 'Cold drink').price_per_piece
    }
  ]
)

order2_pizza_price = pizza4.pizza_sizes.find_by(size: 'medium').price * 1
order2_topping_price = Inventory.find_by(name: 'Chicken tikka').price_per_piece * 1
order2_side_price = Inventory.find_by(name: 'Mousse cake').price_per_piece * 1
order2_total_price = order2_pizza_price + order2_topping_price + order2_side_price

order2 = Order.create!(
  customer: customer2,
  total_price: order2_total_price,
  order_pizzas_attributes: [
    {
      pizza: pizza4,
      crust: 'Wheat thin crust',
      size: 'medium',
      quantity: 1,
      price: pizza4.pizza_sizes.find_by(size: 'medium').price,
      order_pizza_toppings_attributes: [
        {
          inventory: Inventory.find_by(name: 'Chicken tikka'),
          quantity: 1,
          price: Inventory.find_by(name: 'Chicken tikka').price_per_piece
        }
      ]
    }
  ],
  order_sides_attributes: [
    {
      inventory: Inventory.find_by(name: 'Mousse cake'),
      quantity: 1,
      price: Inventory.find_by(name: 'Mousse cake').price_per_piece
    }
  ]
)

order3_pizza_price = pizza3.pizza_sizes.find_by(size: 'large').price * 3
order3_topping_price = Inventory.find_by(name: 'Extra cheese').price_per_piece * 9
order3_side_price = Inventory.find_by(name: 'Cold drink').price_per_piece * 3
order3_total_price = order3_pizza_price + order3_topping_price + order3_side_price

order3 = Order.create!(
  customer: customer3,
  total_price: order3_total_price,
  order_pizzas_attributes: [
    {
      pizza: pizza3,
      crust: 'Cheese Burst',
      size: 'large',
      quantity: 3,
      price: pizza3.pizza_sizes.find_by(size: 'large').price,
      order_pizza_toppings_attributes: [
        {
          inventory: Inventory.find_by(name: 'Extra cheese'),
          quantity: 9,
          price: Inventory.find_by(name: 'Extra cheese').price_per_piece
        }
      ]
    }
  ],
  order_sides_attributes: [
    {
      inventory: Inventory.find_by(name: 'Cold drink'),
      quantity: 3,
      price: Inventory.find_by(name: 'Cold drink').price_per_piece
    }
  ]
)

order4_pizza_price = pizza2.pizza_sizes.find_by(size: 'medium').price * 2
order4_topping_price = Inventory.find_by(name: 'Capsicum').price_per_piece * 2
order4_side_price = Inventory.find_by(name: 'Cold drink').price_per_piece * 1
order4_total_price = order4_pizza_price + order4_topping_price + order4_side_price

order4 = Order.create!(
  customer: customer4,
  total_price: order4_total_price,
  order_pizzas_attributes: [
    {
      pizza: pizza2,
      crust: 'Fresh pan pizza',
      size: 'medium',
      quantity: 2,
      price: pizza2.pizza_sizes.find_by(size: 'medium').price,
      order_pizza_toppings_attributes: [
        {
          inventory: Inventory.find_by(name: 'Capsicum'),
          quantity: 2,
          price: Inventory.find_by(name: 'Capsicum').price_per_piece
        }
      ]
    }
  ],
  order_sides_attributes: [
    {
      inventory: Inventory.find_by(name: 'Cold drink'),
      quantity: 1,
      price: Inventory.find_by(name: 'Cold drink').price_per_piece
    }
  ]
)
