class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :uid, unsigned: true, limit: 8
      t.string :first_name
      t.string :last_name
      t.string :image
      t.string :token
      t.string :secret

      t.timestamps null: false
    end
  end
end
