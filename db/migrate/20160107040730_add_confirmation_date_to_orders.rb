class AddConfirmationDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :confirmation_date, :integer, limit: 8
  end
end
