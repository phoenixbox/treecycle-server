class Address < ActiveRecord::Base
  ADDRESS_TYPES ||= YAML.load(File.open("#{Rails.root}/config/constants/address_types.yml", 'r'))

  # Validations
  validates :lat, presence: true
  validates :lng, presence: true

  # Enums
  as_enum :type, ADDRESS_TYPES

  # Associations
  has_many :address_users, dependent: :destroy
  has_many :users, through: :address_users
  belongs_to :order
end
