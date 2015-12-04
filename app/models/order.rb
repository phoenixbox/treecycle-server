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
  accepts_nested_attributes_for :packages

  after_touch do |order|
    mark_state_for_attributes(order)
  end

  private

  def mark_state_for_attributes(order)
      if (order.address_id && order.packages.length && order.phone_id && order.pickup_dates && order.paid)
        order.status = :paid
        order.save
      end
  end
end
