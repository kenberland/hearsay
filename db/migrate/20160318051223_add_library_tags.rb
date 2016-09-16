class AddLibraryTags < ActiveRecord::Migration
  def up
    add_column :tags, :is_library_tag, :boolean
    add_index :tags, :is_library_tag, name: 'index_is_library_tag_on_tags'
  end

  def down
    remove_column :tags, :is_library_tag
  end
end
