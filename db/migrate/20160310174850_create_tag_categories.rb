class CreateTagCategories < ActiveRecord::Migration
  def up
    create_table :tag_categories do |t|
      t.string 'category'
      t.timestamps null: false
    end
    change_table :tags do |t|
      t.references :tag_category, index: true, foreign_key: true
    end
    add_index :tag_categories, [:category], name: 'index_tag_categories_on_category', unique: true, using: :btree
  end

  def down
    execute 'DROP TABLE tag_categories CASCADE'
    remove_column :tags, :tag_category_id
  end
end
