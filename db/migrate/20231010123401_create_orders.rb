class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_price, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
