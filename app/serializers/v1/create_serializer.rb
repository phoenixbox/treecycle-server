module V1
  class CreateSerializer < ActiveModel::Serializer
    attributes :access_token,
               :uuid,
               :id,
               :email,
               :new_user

     def new_user
       @options[:new_user]
     end
  end
end
