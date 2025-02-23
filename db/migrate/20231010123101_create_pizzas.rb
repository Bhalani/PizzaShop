class CreatePizzas < ActiveRecord::Migration[7.2]
  def change
    create_table :pizzas do |t|
      t.string :name, null: false
      t.boolean :is_vegetarian, null: false

      t.timestamps
    end
  end
end
