module V1
  class UserSerializer < ActiveModel::Serializer
    attributes  :email
                :display_name
                :uuid
                :access_token
                :roles
                :stripe_id

  end
end
