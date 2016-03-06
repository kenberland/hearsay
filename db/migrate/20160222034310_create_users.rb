class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :image
      t.string :token
      t.string :secret

      t.timestamps null: false
    end
  end
end
