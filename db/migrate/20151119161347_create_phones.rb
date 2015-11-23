class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number, null: false
      t.string :authy_id
      t.string :iso2
      t.string :calling_code
      t.boolean :verified, null: false, default: false
      t.integer :phoneable_id
      t.string :phoneable_type
      t.timestamps null: false
    end

    add_index :phones, :authy_id, unique: true
  end
end
