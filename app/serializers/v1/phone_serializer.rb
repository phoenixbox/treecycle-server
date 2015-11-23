module V1
  class PhoneSerializer < ActiveModel::Serializer
    root false
    attributes  :id,
                :number,
                :authy_id,
                :iso2,
                :calling_code,
                :verified,
                :phoneable_id,
                :phoneable_type,
                :created_at,
                :updated_at
  end
end
