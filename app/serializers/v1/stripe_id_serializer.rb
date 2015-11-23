module V1
  class StripeIdSerializer < ActiveModel::Serializer
    attributes  :stripe_id

    def stripe_id
      object.stripe_id
    end
  end
end
