class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories do |t|
      t.string :name, null: false
      t.integer :category
      t.integer :item_type, null: false
      t.decimal :price_per_piece, null: false, precision: 10, scale: 2
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
