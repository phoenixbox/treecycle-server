module V1
  class UsersController < ApplicationController
    include ErrorSerializer
    skip_before_action :authenticate_user_from_token!, only: [:create, :signup, :google]

    # POST /v1/users
    # ${token} string
    # ${profile} oauth profile - ref below
    # ${provider} string

    # Creates an user
    def create
      # Assumes an authentication record exists for the social provider
      # If not then its a new user signup
      # This is poor implementation
      new_user = false
      auth = Authentication.where({uid: user_params['profile']['id'], provider: user_params['provider']}).take
      if !auth
        @user = User.from_oauth(user_params)
        new_user = true
        if !@user.errors.empty?
          render json: ErrorSerializer.serialize(@user.errors), status: :unprocessable_entity
          return
        end
      else
        # Auth exists - need to update the long lived token
        auth.token = user_params['profile']['token']
        auth.save
        # Do need to add auth to token check?
        @user = auth.user
      end
      # @user = User.find_by_email('phoenixbananabox@yahoo.ie')

      if @user
        render json: @user, new_user: new_user, serializer: V1::CreateSerializer, root: nil
      else
        render json: ErrorSerializer.serialize(@user.errors), status: :unprocessable_entity
      end
    end

    def google
      auth = Authentication.where({uid: google_user_params['profile']['id'], provider: google_user_params['provider']}).take

      if !auth
        @user = User.from_google_oauth(google_user_params)

        if !@user.errors.empty?
          render json: ErrorSerializer.serialize(@user.errors), status: :unprocessable_entity
          return
        end
      else
        @user = auth.user
      end

      if @user
        render json: @user, serializer: V1::CreateSerializer, root: nil
      else
        render json: ErrorSerializer.serialize(@user.errors), status: :unprocessable_entity
      end
    end

    def signup
      @user = User.new(signup_params)

      if @user.save
        render json: @user, new_user: true, serializer: V1::CreateSerializer, root: nil
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
        redirect_to v1_user_path(@user)
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
      params.require(:user).permit(:token, :email, {:profile => profile_params}, :provider, :stripe_id)
    end

    def google_user_params
      params.require(:user).permit(:token, {:profile => google_profile_params}, :provider, :stripe_id)
    end

    # Second Level Profile Keys
    def profile_params
      [:id, :display_name, {:name => name_params}, :email, {:raw => facebook_raw_params}, :photo_url, :token, :token_type, :expiration ]
    end

    def google_profile_params
      [:id, :display_name, {:name => name_params}, :email, {:raw => google_raw_params}, :photo_url, :token, :token_type, :expiration ]
    end

    def name_params
      [
        :first,
        :last,
        :middle
      ]
    end

    # Third Level Raw Keys
    def facebook_raw_params
      [
        :id,
        :name,
        :email,
        :first_name,
        :last_name,
        :middle_name,
        :gender,
        :link,
        :locale,
        :timezone,
        :updated_time,
        :verified
      ]
    end

    def google_raw_params
      [
        :kind,
        :etag,
        {emails: [:value, :type]},
        :objectType,
        :id,
        :displayName,
        {:name => google_raw_name},
        :url,
        {:image => google_raw_image},
        :isPlusUser,
        :language,
        :circledByCount,
        :verified,
        :domain
      ]
    end

    def google_raw_image
      [:url, :isDefault]
    end

    def google_raw_name
      [:familyName, :givenName]
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
