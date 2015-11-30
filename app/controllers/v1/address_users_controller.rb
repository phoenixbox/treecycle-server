module V1
  class AddressUsersController < ApplicationController
    include ErrorSerializer

    def index
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @address = user.addresses
        render json: @address, each_serializer: V1::AddressSerializer, root: nil
      else
        authentication_error
      end
    end

    def create
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        addresses = user.addresses
        if addresses
          coords = address_coords(addresses)
          @existing_address = existing_address(coords)
        end

        if @existing_address
          puts 'address already exists'
          render json: @existing_address, serializer: V1::AddressSerializer, root: nil
        else
          @address = user.addresses.create!(address_params)

          if @address.save
            render json: @address, serializer: V1::AddressSerializer, root: nil
          else
            render json: ErrorSerializer.serialize(@address.errors), status: :unprocessable_entity
          end
        end
      else
        authentication_error
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

    def update
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @address = user.addresses.find_by_id(params[:id])
        if @address.update!(address_params)
          redirect_to v1_user_address_path(user.id , @address.id)
        else
          render json: { error: t('Order_update_error') }, status: :unprocessable_entity
        end
      else
        authentication_error
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

    	params.require(:address_user).permit(:label, :type_cd, :lat, :lng, {:address_components => address_components_params}, :description)
    end

    # Setting to an empty array means that values must be valid scalar values - (number or a chunk of text)
    def address_components_params
      [:long_name, :short_name, {:types => []}]
    end

    def convert_lat_long_to_decimal
      [:lat, :lng].each do |param|
        if params[:address_user][param]
          params[:address_user][param] = params[:address_user][param].to_d
        end
      end
    end
  end
end
