module V1
  class UserSerializer < ActiveModel::Serializer
    attributes  :email
                :access_token
                :uuid
                :display_name
                :roles
                :stripe_id

  end
end
