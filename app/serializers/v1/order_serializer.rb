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
                :address,
                :phone_id,
                :phone,
                :created_at,
                :updated_at

    has_many :packages
    has_many :pickup_dates

    def status
      object.status.to_s
    end

    def address
      Address.find_by_id(object.address_id)
    end

    def phone
      Phone.find_by_id(object.phone_id)
    end
  end
end
