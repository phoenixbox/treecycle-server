module V1
  class UsersController < ApplicationController
    include ErrorSerializer
    skip_before_action :authenticate_user_from_token!, only: [:create, :signup]

    # POST /v1/users
    # ${token} string
    # ${profile} oauth profile - ref below
    # ${provider} string

    # Creates an user
    def create
      # Does an authentication exist for the user && the provider
      auth = Authentication.where({uid: user_params['profile']['id'], provider: user_params['provider']}).take

      if !auth
        @user = User.from_oauth(user_params)
      else
        # Auth exists - need to update the long lived token
        auth.token = user_params['profile']['token']
        auth.save
        @user = auth.user
      end

      if @user.save
        render json: @user, serializer: V1::CreateSerializer, root: nil
      else
        render json: { error: t('user_create_error') }, status: :unprocessable_entity
      end
    end

    def signup
      @user = User.new(signup_params)

      if @user.save
        render json: @user, serializer: V1::CreateSerializer, root: nil
      else
        render json: ErrorSerializer.serialize(@user.errors), status: :unprocessable_entity
      end
    end

    def show
      @user = User.find(params[:id])

      if @user
        render json: @user, serializer: V1::UserSerializer, root: nil
      else
        render json: { error: t('user_show_error') }, status: :unprocessable_entity
      end
    end

    def update
      @user = User.find(params[:id])

      if @user.update!(user_params)
        redirect_to @user
      else
        render json: { error: t('user_update_error') }, status: :unprocessable_entity
      end
    end

    def stripe_id
      @user = User.find(params[:id])

      if @user
        render json: @user, serializer: V1::StripeIdSerializer, root: nil
      else
        render json: { error: "No user exists for provided id" }, status: 400
      end
    end

    def phones
      user = User.find(params[:user_id])

      if user
        @phones = user.phones
        render json: @phones, each_serializer: V1::PhoneSerializer, root: nil
      else
        render json: { error: "No user exists for provided id" }, status: 400
      end
    end

    private
    # First Level Oauth Keys
    def signup_params
      params.require(:user).permit(:email, :display_name, :password, :password_confirmation)
    end

    def user_params
      params.require(:user).permit(:token, :stripe_id, :provider, :refreshToken, {:profile => facebook_profile_params})
    end
    # Second Level Profile Keys
    def facebook_profile_params
      [:id, :name, :email, :photo_url, :token, :token_type, :expiration, {:raw => facebook_raw_params} ]
    end
    # Third Level Raw Keys
    def facebook_raw_params
      [
        :name,
        :id
      ]
    end
  end
end

# { --- Bell oAuth KV Pairs ---
#   provider: 'facebook',
#   token: '',
#   refreshToken: undefined,
#   expiresIn: undefined,
#   query: {},
#   profile: { --- Provider Specific oAuth KV Pairs ---
#    id: '123',
#    username: undefined,
#    displayName: 'Shane Rogers',
#    email: undefined || allowed via permissions,
#    photo_url: fetched through separate call,
#    email: undefined,
#    name: {
#     first: undefined,
#     last: undefined,
#     middle: undefined
#    },
#    raw: { --- Third Level Raw Keys ---
#     name: 'Shane Rogers',
#     id: '123'
#    }
#   }
# }
