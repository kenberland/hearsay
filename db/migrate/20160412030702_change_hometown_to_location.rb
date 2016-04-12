class ChangeHometownToLocation < ActiveRecord::Migration
  def change
    remove_column :users, :hometown
    add_column :users, :location, :string, { limit: 255 }
  end
end
