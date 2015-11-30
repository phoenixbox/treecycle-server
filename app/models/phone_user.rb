class PhoneUser < ActiveRecord::Base
  belongs_to :phone
  belongs_to :user
end
