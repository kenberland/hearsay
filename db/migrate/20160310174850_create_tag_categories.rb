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
    execute "INSERT into tag_categories (category, created_at, updated_at) values ('finance', now(), now())"
    execute "INSERT into tag_categories (category, created_at, updated_at) values ('roomates', now(), now())"
    execute "INSERT into tag_categories (category, created_at, updated_at) values ('work', now(), now())"
    execute "INSERT into tag_categories (category, created_at, updated_at) values ('relationships', now(), now())"
    execute "INSERT into tag_categories (category, created_at, updated_at) values ('school', now(), now())"
    execute "INSERT into tag_categories (category, created_at, updated_at) values ('sports', now(), now())"
  end

  def down
    execute 'DROP TABLE tag_categories CASCADE'
    remove_column :tags, :tag_category_id
  end
end
