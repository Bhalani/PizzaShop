class CreateOrderPizzaToppings < ActiveRecord::Migration[7.2]
  def change
    create_table :order_pizza_toppings do |t|
      t.references :order_pizza, null: false, foreign_key: true
      t.references :inventory, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :price, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
