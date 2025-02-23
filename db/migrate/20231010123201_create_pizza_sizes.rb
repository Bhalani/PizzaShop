class CreatePizzaSizes < ActiveRecord::Migration[7.2]
  def change
    create_table :pizza_sizes do |t|
      t.references :pizza, null: false, foreign_key: true
      t.integer :size, null: false
      t.decimal :price, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
