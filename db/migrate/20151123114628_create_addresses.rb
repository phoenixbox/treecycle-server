class CreateAddresses < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    create_table :addresses do |t|
      t.string   :label, null: false
      t.decimal  :lat, {:precision=>10, :scale=>6}
      t.decimal  :lng, {:precision=>10, :scale=>6}
      t.integer  :type_cd, null: false
      t.jsonb :address_components, null: false, default: '{}'
      t.integer  :addressable_id
      t.string   :addressable_type
      t.text     :description
      t.timestamps null: false
    end
    add_index :addresses, :type_cd
    add_index :addresses, :address_components, using: :gin
  end
end
