class ChangePickupDateType < ActiveRecord::Migration
  def change
    remove_column :orders, :pickup_dates
  end
end
