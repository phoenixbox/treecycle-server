class AddCancelledToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :cancelled, :boolean, default: false, null: false
  end
end
