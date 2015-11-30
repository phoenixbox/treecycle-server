class UpdateFacebookProfile < ActiveRecord::Migration
  def change
    remove_column :facebook_profiles, :username
    change_column :facebook_profiles, :raw, 'jsonb USING CAST(raw AS jsonb)', null: false, default: '{}'
    add_column :facebook_profiles, :name, :jsonb, null: false, default: '{}'
  end
end
