module V1
  class OrderSerializer < ActiveModel::Serializer
    attributes  :id,
                :uuid,
                :status,
                :amount,
                :currency,
                :description,
                :paid,
                :charge_id,
                :address_id,
                :phone_id,
                :created_at,
                :updated_at

    has_many :packages
    has_many :pickup_dates

    def status
      object.status.to_s
    end
  end
end
