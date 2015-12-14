class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :uid, null: false
      t.string :provider, null: false
      t.string :token
      t.string :token_type
      t.integer :user_id, null: false
      t.integer :expiration
      t.timestamps null: false
    end
  end
end
