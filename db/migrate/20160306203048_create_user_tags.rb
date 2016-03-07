class CreateUserTags < ActiveRecord::Migration
  def change
    create_table :user_tags do |t|
      t.references :tag, index: true, foreign_key: true
      t.integer :from_user_uid, unsigned: true, limit: 8, index: true, foreign_key: true
      t.integer :to_user_uid, unsigned: true, limit: 8, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
