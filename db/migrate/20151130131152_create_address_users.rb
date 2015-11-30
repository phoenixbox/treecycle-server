class CreateAddressUsers < ActiveRecord::Migration
  def change
    create_table :address_users do |t|
      t.belongs_to :address, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
