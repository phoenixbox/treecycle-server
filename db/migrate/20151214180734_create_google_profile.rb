class CreateGoogleProfile < ActiveRecord::Migration
  def change
    create_table :google_profiles do |t|
      t.string :uid, null: false
      t.string :display_name
      t.jsonb :name
      t.string :email
      t.text :photo_url
      t.jsonb :raw, null: false, default: '{}'
      t.integer :authentication_id, null: false
    end
    add_index :google_profiles, :raw, using: :gin
  end
end
