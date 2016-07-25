class ChangeFromAndToIdToStrings < ActiveRecord::Migration
  def change
    change_column :user_tags, :to_user_uid, :string, :null => false
    change_column :user_tags, :from_user_uid, :string, :null => false
  end
end
