module V1
  class OrderSerializer < ActiveModel::Serializer
    attributes  :id,
                :uuid,
                :status,
                :amount,
                :currency,
                :description,
                :paid,
                :address_id,
                :phone_id,
                :created_at,
                :updated_at

    has_many :packages

    def status
      object.status.to_s
    end
  end
end
