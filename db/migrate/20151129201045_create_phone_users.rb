class CreatePhoneUsers < ActiveRecord::Migration
  def change
    create_table :phone_users do |t|
      t.belongs_to :phone, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
