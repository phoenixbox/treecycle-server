module V1
  class SessionSerializer < ActiveModel::Serializer
    attributes  :access_token,
                :token_type,
                :id,
                :uuid,
                :email,
                :facebook_display_name,
                :facebook_photo_url,
                :facebook_token,
                :facebook_uid,
                :google_display_name,
                :google_photo_url

    def access_token
      object.access_token
    end

    def token_type
      'Bearer'
    end

    def id
      object.id
    end

    def uuid
      object.uuid
    end

    def email
      object.email
    end

    def facebook_uid
      @options[:facebook_profile] ? @options[:facebook_profile].uid : ''
    end

    def facebook_display_name
      @options[:facebook_profile] ? @options[:facebook_profile].display_name : ''
    end

    def facebook_photo_url
      @options[:facebook_profile] ? @options[:facebook_profile].photo_url : ''
    end

    def facebook_token
      @options[:facebook_profile] ? @options[:facebook_profile].token : ''
    end

    def google_display_name
      @options[:google_profile] ? @options[:google_profile].display_name : ''
    end

    def google_photo_url
      @options[:google_profile] ? @options[:google_profile].photo_url : ''
    end
  end
end
