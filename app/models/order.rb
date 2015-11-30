class Order < ActiveRecord::Base
  as_enum :status, incomplete: 0, complete: 1, charged: 2, paid: 3, processing: 4, delivered: 5, refunded: 6, disputed: 7
  validates :uuid, presence: true, uniqueness: true

  # Associations
  belongs_to :user
  has_many :packages, dependent: :destroy
  has_many :pickup_dates, dependent: :destroy

  has_one :address

  # Nested Attrs
  accepts_nested_attributes_for :pickup_dates
end
