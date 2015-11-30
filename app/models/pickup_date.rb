class PickupDate < ActiveRecord::Base
  # Associations
  belongs_to :order, dependent: :destroy
  # Validations
  validates :order_id, uniqueness: { scope: [:date] }
end
