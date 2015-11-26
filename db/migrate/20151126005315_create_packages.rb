class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :type_cd, index: true
      t.belongs_to :order, index: true
      t.string :size_value
      t.string :size_unit
    end
  end
end
