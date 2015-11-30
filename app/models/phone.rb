class Phone < ActiveRecord::Base
  # Associations
  has_many :phone_users
  has_many :users, through: :phone_users
end
