class AddPhotoUrlToFacebookProfile < ActiveRecord::Migration
  def change
    add_column :facebook_profiles, :photo_url, :text
  end
end
