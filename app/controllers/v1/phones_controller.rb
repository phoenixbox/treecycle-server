module V1
  class PhonesController < ApplicationController
    # Create a new phone
    # @param String number
    # @param String country_code
    # @param Object Phone

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
    # First Level Oauth Keys
    def phone_params
      params.require(:phone).permit(:number, :authy_id, :iso2, :calling_code, :verified, :phoneable_id, :phoneable_type)
    end
  end
end
