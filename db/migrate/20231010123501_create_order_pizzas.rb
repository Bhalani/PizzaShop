class CreateOrderPizzas < ActiveRecord::Migration[7.2]
  def change
    create_table :order_pizzas do |t|
      t.references :order, null: false, foreign_key: true
      t.references :pizza, null: false, foreign_key: true
      t.string :crust, null: false
      t.integer :size, null: false
      t.integer :quantity, null: false
      t.decimal :price, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
