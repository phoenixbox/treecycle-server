class PickupDate < ActiveRecord::Base
  # Associations
  belongs_to :order
  # Validations
  validates :order_id, uniqueness: { scope: [:date] }
end
