class ModifyUniqueTagToIncludeCategory < ActiveRecord::Migration
  def change
    remove_index :tags, :tag
    add_index :tags, [:tag, :tag_category_id], unique: true
  end
end
