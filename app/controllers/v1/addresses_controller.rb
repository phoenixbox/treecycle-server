module V1
  class AddressesController < ApplicationController
    include ErrorSerializer

    def index
      # Should have a consistent params naming convetion
      # Convert these params to address_params
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
      klass = address_params[:addressable_type].capitalize.constantize
      addresses = klass.find(address_params[:addressable_id]).addresses

      if addresses
        coords = address_coords(addresses)
        existing_address = existing_address(coords)
      end

      if existing_address
        errors = {:errors => {:id => 'address', :title => 'already exists'}}
        render json: errors, status: :unprocessable_entity
      else
        @address = Address.where(address_params).new

        if @address.save
          render json: @address, serializer: V1::AddressSerializer, root: nil
        else
          render json: ErrorSerializer.serialize(@address.errors), status: :unprocessable_entity
        end
      end
    end

    private

    def address_coords addresses
      addresses.map{ |ad| { lat: ad[:lat].to_s, lng: ad[:lng].to_s}}
    end

    def existing_address(coords)
      # Round to the 6 precision cosntraint in the db
      latParam = address_params[:lat].round(6).to_s
      lngParam = address_params[:lng].round(6).to_s
      coords.find {|coord| coord[:lat]==latParam && coord[:lng]==lngParam}
    end

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
