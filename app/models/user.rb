class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable,
         :recoverable,
         :trackable

  after_create :update_access_token!

  # Validations
  # validates :email, uniqueness: true, :format => { :with =>  Devise::email_regexp }
  # Associations
  has_many :authentications, dependent: :destroy
  has_many :phone_users, dependent: :destroy
  has_many :phones, through: :phone_users

  has_many :address_users, dependent: :destroy
  has_many :addresses, through: :address_users

  has_many :orders do
    def by_status(status)
       where(:status_cd => status)
    end
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def self.from_oauth(params)
    password = Devise.friendly_token[0,20]

    begin
      user = User.new({
        :email => params['profile']['email'],
        :display_name => params['profile']['display_name'],
        :uuid => "",
        :password => password,
        :password_confirmation => password
      })
      user.save!
      user.createAuthentication(params)
      user
    rescue ActiveRecord::RecordInvalid => invalid
       user
    end
  end

  def createAuthentication(params)
    auth = self.authentications.create!({
      :uid => params['profile']['id'],
      :provider => params['provider'],
      :token => params['profile']['token'],
      :token_type => params['profile']['token_type'],
      :expiration => params['profile']['expiration']
    })

    createFacebookProfile(auth, params)
  end

  def createFacebookProfile(auth, params)
    FacebookProfile.create!({
      :uid => params['profile']['id'],
      :display_name => params['profile']['display_name'],
      :name => params['profile']['name'],
      :email => params['profile']['email'],
      :raw => params['profile']['raw'],
      :photo_url => params['profile']['photo_url'],
      :token => auth.token,
      :authentication_id => auth.id
    })
  end

  private

  def update_access_token!
    # Do I have access to the original params? or do they need to be passed in?
    uuid = SecureRandom.base64
    self.uuid = uuid
    self.access_token = generate_access_token(uuid)
    save
  end

  def generate_access_token(uuid)
    loop do
      token = "#{uuid}:#{Devise.friendly_token}"
      break token unless User.where(access_token: token).first
    end
  end
end
