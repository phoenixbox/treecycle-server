module V1
  class OrderSerializer < ActiveModel::Serializer
    attributes  :id,
                :uuid,
                :status,
                :amount,
                :currency,
                :description,
                :paid,
                :created_at,
                :updated_at

    has_one :phone
    has_one :address
    has_many :packages

    def status
      object.status.to_s
    end
  end
end
