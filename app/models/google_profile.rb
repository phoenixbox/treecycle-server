class GoogleProfile < ActiveRecord::Base
  belongs_to :authentication, dependent: :destroy

  validates :uid, presence: true
  validates :authentication_id, presence: true
end
