class AddressUser < ActiveRecord::Base
  belongs_to :address, dependent: :destroy
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:address_id] }
end
