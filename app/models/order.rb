class Order < ActiveRecord::Base
  as_enum :status, incomplete: 0, complete: 1, charged: 2, paid: 3, processing: 4, delivered: 5, refunded: 6, disputed: 7
  validates :uuid, presence: true, uniqueness: true

  # Associations
  belongs_to :user
  has_one :phone
  has_one :address
  has_many :packages
end
