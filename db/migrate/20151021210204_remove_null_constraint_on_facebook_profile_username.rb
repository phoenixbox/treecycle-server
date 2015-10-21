class RemoveNullConstraintOnFacebookProfileUsername < ActiveRecord::Migration
  def change
    change_column :facebook_profiles, :username, :string, :null => true
  end
end
