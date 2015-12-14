module V1
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user_from_token!

    # POST /v1/login
    def create
      full_access_token = [params[:uuid],params[:access_token]].join(':')
      @user = User.where({uuid: params[:uuid], access_token: full_access_token}).take

      return invalid_login_attempt unless @user
      if @user
        sign_in :user, @user
        # Implicit namespaced to V1::SessionSerializer
        fbAuth = @user.authentications.find_by_provider('facebook')
        googleAuth = @user.authentications.find_by_provider('google')

        if fbAuth || googleAuth
          fbProfile = false
          googleProfile = false
          if fbAuth
            fbProfile = FacebookProfile.find_by_authentication_id(fbAuth.id)
          end
          if googleAuth
            googleProfile = GoogleProfile.find_by_authentication_id(googleAuth.id) || null
          end

          render json: @user, facebook_profile: fbProfile, google_profile: googleProfile, serializer: SessionSerializer, root: nil
        else
          render json: @user, serializer: SessionSerializer, root: nil
        end

      else
        invalid_login_attempt
      end
    end

    # POST /v1/sign-in
    def create_from_email
      @user = User.find_for_database_authentication(email: params[:email])
      return invalid_login_attempt unless @user

      if @user.valid_password?(params[:password])
        sign_in :user, @user
        render json: @user, serializer: SessionSerializer, root: nil
      else
        invalid_login_attempt
      end
    end

    private

    def invalid_login_attempt
      puts 'INVALID LOGIN ATTEMPT'
      warden.custom_failure!
      render json: {error: t('sessions_controller.invalid_login_attempt')}, status: :unprocessable_entity
    end
  end
end
