class CreatePickupDates < ActiveRecord::Migration
  def change
    create_table :pickup_dates do |t|
      t.belongs_to :order, index: true
      t.integer :date, :limit => 8, index: true
    end
  end
end
