module V1
  class PhoneUsersController < ApplicationController

    def index
      user = User.find_by_id(params[:user_id])

      if (authorize_user(user))
        @phones = user.phones
        render json: @phones, each_serializer: V1::PhoneSerializer, root: nil
      else
        authentication_error
      end
    end

    private

    def phone_user_params
      params.require(:phone).permit(:user_id, :number, :authy_id, :iso2, :calling_code, :verified)
    end
  end
end
