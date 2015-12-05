class Order < ActiveRecord::Base
  STATUS_TYPES ||= YAML.load(File.open("#{Rails.root}/config/constants/status_types.yml", 'r'))
  as_enum :status, STATUS_TYPES

  validates :uuid, presence: true, uniqueness: true

  # Associations
  belongs_to :user
  has_many :packages, dependent: :destroy
  has_many :pickup_dates, dependent: :destroy
  has_one :address

  # Nested Attrs
  accepts_nested_attributes_for :pickup_dates
  accepts_nested_attributes_for :packages

  after_update :mark_state_for_attributes


  private

  def mark_state_for_attributes
      if self.status.to_s == "paid"
        return
      end

      if self.address_id && self.packages.length && self.phone_id && self.pickup_dates
        self.status = "paid"
        self.save
      end
  end
end
