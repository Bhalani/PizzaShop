class Inventory < ApplicationRecord
  enum :item_type, %i[topping side crust]
  enum :category, %i[veg non_veg], validates: { allow_nil: true }

  validates :name, :price_per_piece, :quantity, :item_type, presence: true
  validates :item_type, inclusion: { in: item_types.keys }
  validates :quantity, numericality: { only_integer: true }
  validates :price_per_piece, numericality: true
end
