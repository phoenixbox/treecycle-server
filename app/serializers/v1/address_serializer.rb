module V1
  class AddressSerializer < ActiveModel::Serializer
    attributes  :id,
                :label,
                :lat,
                :lng,
                :type,
                :address_components,
                :description,
                :created_at,
                :updated_at

    def type
      object.type.to_s
    end
  end
end
