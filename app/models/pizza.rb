class Pizza < ApplicationRecord
  has_many :pizza_sizes, dependent: :destroy
  accepts_nested_attributes_for :pizza_sizes, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :is_vegetarian, inclusion: { in: [ true, false ] }
  validates :pizza_sizes, presence: true

  default_scope { includes(:pizza_sizes) }
end
