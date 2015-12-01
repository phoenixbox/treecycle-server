module V1
  class PhoneUsersController < ApplicationController
    include ErrorSerializer

    def index
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @phones = user.phones
        render json: @phones, each_serializer: V1::PhoneSerializer, root: nil
      else
        authentication_error
      end
    end

    def create
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @phone = user.phones.where(number: params[:phone_user][:number]).first

        if @phone
          render json: @phone, serializer: V1::PhoneSerializer, root: nil
        else
          @phone = user.phones.create!(phone_user_params)

          if (@phone)
            render json: @phone, serializer: V1::PhoneSerializer, root: nil
          else
            render json: ErrorSerializer.serialize(@phone.errors), status: :unprocessable_entity
          end
        end
      else
        authentication_error
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

    def update
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @phone = user.phones.find_by_id(params[:id])

        if @phone.update!(phone_user_params)
          redirect_to v1_user_phone_path(user.id , @phone.id)
        else
          render json: { error: t('phone_update_error') }, status: :unprocessable_entity
        end
      else
        authentication_error
      end
    end

    private

    def phone_user_params
      params.require(:phone_user).permit(:number, :authy_id, :iso2, :calling_code, :verified)
    end
  end
end
