class PhoneUser < ActiveRecord::Base
  belongs_to :phone, dependent: :destroy
  belongs_to :user, dependent: :destroy
end
