class AddressUser < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:address_id] }
end
