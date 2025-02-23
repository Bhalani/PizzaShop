# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2023_10_10_123701) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category"
    t.integer "item_type", null: false
    t.decimal "price_per_piece", precision: 10, scale: 2, null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_pizza_toppings", force: :cascade do |t|
    t.bigint "order_pizza_id", null: false
    t.bigint "inventory_id", null: false
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_order_pizza_toppings_on_inventory_id"
    t.index ["order_pizza_id"], name: "index_order_pizza_toppings_on_order_pizza_id"
  end

  create_table "order_pizzas", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "pizza_id", null: false
    t.string "crust", null: false
    t.integer "size", null: false
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_pizzas_on_order_id"
    t.index ["pizza_id"], name: "index_order_pizzas_on_pizza_id"
  end

  create_table "order_sides", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "inventory_id", null: false
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_order_sides_on_inventory_id"
    t.index ["order_id"], name: "index_order_sides_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  create_table "pizza_sizes", force: :cascade do |t|
    t.bigint "pizza_id", null: false
    t.integer "size", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pizza_id"], name: "index_pizza_sizes_on_pizza_id"
  end

  create_table "pizzas", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_vegetarian", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "order_pizza_toppings", "inventories"
  add_foreign_key "order_pizza_toppings", "order_pizzas"
  add_foreign_key "order_pizzas", "orders"
  add_foreign_key "order_pizzas", "pizzas"
  add_foreign_key "order_sides", "inventories"
  add_foreign_key "order_sides", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "pizza_sizes", "pizzas"
end
