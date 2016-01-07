module V1
  class OrderSerializer < ActiveModel::Serializer
    attributes  :id,
                :uuid,
                :user_email,
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
                :phone,
                :confirmation_date,
                :confirmation_status,
                :cancelled,
                :created_at,
                :updated_at

    has_many :packages
    has_many :pickup_dates

    def status
      object.status.to_s
    end

    def confirmation_status
      object.confirmation_status.to_s
    end

    def user_email
      object.user.email
    end

    def address
      Address.find_by_id(object.address_id)
    end

    def phone
      Phone.find_by_id(object.phone_id)
    end
  end
end
