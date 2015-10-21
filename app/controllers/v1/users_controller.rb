module V1
  class UsersController < ApplicationController
    skip_before_action :authenticate_user_from_token!, only: [:create]

    # POST /v1/users
    # ${token} string
    # ${profile} oauth profile - ref below
    # ${provider} string

    # Creates an user
    def create
      # Does an authentication exist for the user
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

    private
    # First Level Oauth Keys
    def user_params
      params.require(:user).permit(:token, :provider, :refreshToken, {:profile => facebook_profile_params})
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
