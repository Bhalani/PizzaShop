class PizzaSize < ApplicationRecord
  belongs_to :pizza

  enum :size, %i[regular medium large]

  validates :size, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
