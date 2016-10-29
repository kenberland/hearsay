class CreatePhoneNumberRegistrations < ActiveRecord::Migration
  def change
    create_table :phone_number_registrations do |t|
      t.string :device_phone_number, limit: 255
      t.string :device_uuid

      t.timestamps null: false
    end
  end
end
