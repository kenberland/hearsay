class RemoveUniqueUidRestriction < ActiveRecord::Migration
  def change
    change_column :users, :uid, :string, :null => true
  end
end
