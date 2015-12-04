class PickupDate < ActiveRecord::Base
  # Associations
  belongs_to :order, touch: true
  # Validations
  validates :order_id, uniqueness: { scope: [:date] }
end
