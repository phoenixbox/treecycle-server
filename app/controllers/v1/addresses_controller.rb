module V1
  class AddressesController < ApplicationController
    skip_before_action :authenticate_user_from_token!, only: [:create]
    def index
      @addresses = []
      if (params[:addressable_id] && params[:addressable_type])
        klass = params[:addressable_type].capitalize.constantize
        @addresses = klass.find(params[:addressable_id]).addresses
      else
        @addresses = Address.all
      end
      render json: @addresses, each_serializer: V1::AddressSerializer, root: nil
    end

    def update
      @address = Address.find(params[:id])

      if @address.update!(address_params)
        redirect_to v1_address_path(@address)
      else
        render json: { error: t('address_update_error') }, status: :unprocessable_entity
      end
    end

    def show
      @address = Address.find(params[:id])

      if @address
        render json: @address, serializer: V1::AddressSerializer, root: nil
      else
        render json: { error: t('address_show_error') }, status: :unprocessable_entity
      end
    end

    def create
      binding.pry
      @address = Address.where(address_params).first_or_initialize

      if @address.save
        render json: @address, serializer: V1::AddressSerializer, root: nil
      else
        render json: { error: t('address_create_error') }, status: :unprocessable_entity
      end
    end

    private

    def address_params
    	convert_lat_long_to_decimal

    	params.require(:address).permit(:label, :type_cd, :lat, :lng, {:address_components => address_components_params}, :description, :addressable_id, :addressable_type)
    end

    # Setting to an empty array means that values must be valid scalar values - (number or a chunk of text)
    def address_components_params
      [:long_name, :short_name, {:types => []}]
    end

    def convert_lat_long_to_decimal
      [:lat, :lng].each {|param| params[:address][param] = params[:address][param].to_d}
    end
  end
end
