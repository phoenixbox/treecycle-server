module V1
  class PasswordResetsController < ApplicationController
    skip_before_action :authenticate_user_from_token!, only: [:create, :reset]

    def create
      user = User.find_by({email: params[:email]})
      if user
        user.regenerate_reset_password_token
        render json: {reset_password_token: user.reset_password_token}
      else
        render json: { error: t('no_email_exists') }, status: :unprocessable_entity
      end
    end

    def reset
      if @user = User.find_by({reset_password_token: params[:token]})
        @user.update({
          password: password_params['password'],
          reset_password_token: nil
        })
        @user.regenerate_access_token
        render json: @user, serializer: V1::CreateSerializer, root: nil
      else
        render json: { error: t('reset_token_incorrect') }, status: :unprocessable_entity
      end
    end

    private

    def password_params
      params.require(:password_reset).permit(:password)
    end
  end
end
