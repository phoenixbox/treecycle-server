class ConvertAddressToHabtm < ActiveRecord::Migration
  def change
    remove_column :addresses, :addressable_id, :integer
    remove_column :addresses, :addressable_type, :string
  end
end
