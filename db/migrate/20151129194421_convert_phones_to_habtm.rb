class ConvertPhonesToHabtm < ActiveRecord::Migration
  def change
    remove_column :phones, :phoneable_id
    remove_column :phones, :phoneable_type
  end
end
