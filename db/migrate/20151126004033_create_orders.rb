class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :uuid, null: false
      t.integer :status_cd
      t.integer :amount
      t.integer :address_id
      t.integer :phone_id
      t.string :currency
      t.string :charge_id
      t.text :description
      t.boolean :paid, default: false, null: false
      t.references :user, index: true
      t.integer :pickup_dates, array: true, default: []
    end
  end
end
