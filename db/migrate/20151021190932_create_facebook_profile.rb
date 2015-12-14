class CreateFacebookProfile < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    create_table :facebook_profiles do |t|
      t.string :uid, null: false
      t.string :username, null: false
      t.string :display_name, null: false
      t.string :email
      t.integer :authentication_id, null: false
      t.string :token, null: false
      t.hstore :raw
    end
    add_index :facebook_profiles, :raw, using: :gin
  end
end
