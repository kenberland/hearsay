class AddHometownToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hometown, :string, { limit: 255 }
  end
end
