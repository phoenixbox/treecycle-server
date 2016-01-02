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
  accepts_nested_attributes_for :pickup_dates, allow_destroy: true
  accepts_nested_attributes_for :packages

  after_update :mark_state_for_attributes

  private

  def mark_state_for_attributes
    # If the order is complete update the status
    # Complete - address - min 1 package - phone number - min 1 pickup date - amount set
    if(self.address_id.present? && !self.packages.empty? && self.phone_id.present? && !self.pickup_dates.empty? && self.amount.present?)
      new_status = "complete"

      # if paid update the status to paid
      if self.paid
        new_status = "paid"
      end

      # if cancelled update the status to refunded
      if self.cancelled
        new_status = "refunded"
      end

      # Only call save if its new otherwise we get stuck in an after save callback loop
      if self.status.to_s != new_status
        self.status = new_status
        self.save
      end
    end
  end
end
