class AddConfirmationStatusToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :confirmation_status_cd, :integer, default: 0
  end
end
