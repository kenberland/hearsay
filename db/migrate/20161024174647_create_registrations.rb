class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :registration_id
      t.string :device_uuid

      t.timestamps null: false
    end
  end
end
