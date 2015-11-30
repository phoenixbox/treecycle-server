module V1
  class PhonesController < ApplicationController
    # Create a new phone
    # @param String number
    # @param String country_code
    # @param Object Phone

    def index
      # Should have a consistent params naming convetion
      # Convert these params to address_params
      
      @phones = []
      if (phone_params[:phoneable_id] && phone_params[:phoneable_type])
        klass = phone_params[:phoneable_type].capitalize.constantize
        @phones = klass.find(phone_params[:phoneable_id]).phones
      else
        @phones = Phone.all
      end
      render json: @phones, each_serializer: V1::PhoneSerializer, root: nil
    end

    def update
      @phone = Phone.find(params[:id])

      if @phone.update!(phone_params)
        redirect_to v1_phone_path(@phone)
      else
        render json: { error: t('phone_update_error') }, status: :unprocessable_entity
      end
    end

    def show
      @phone = Phone.find(params[:id])

      if @phone
        render json: @phone, serializer: V1::PhoneSerializer, root: nil
      else
        render json: { error: t('phone_show_error') }, status: :unprocessable_entity
      end
    end

    def create
      @phone = Phone.where(phone_params).first_or_initialize

      if @phone.save
        render json: @phone, serializer: V1::PhoneSerializer, root: nil
      else
        render json: { error: t('phone_create_error') }, status: :unprocessable_entity
      end
    end

    private

    def phone_params
      params.require(:phone).permit(:number, :authy_id, :iso2, :calling_code, :verified, :phoneable_id, :phoneable_type)
    end
  end
end
