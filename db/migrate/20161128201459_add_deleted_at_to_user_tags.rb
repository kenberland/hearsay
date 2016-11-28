class AddDeletedAtToUserTags < ActiveRecord::Migration
  def change
    add_column :user_tags, :deleted_at, :datetime
    add_index :user_tags, :deleted_at
  end
end
