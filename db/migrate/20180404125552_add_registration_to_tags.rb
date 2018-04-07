class AddRegistrationToTags < ActiveRecord::Migration
  def up
    add_reference :tags, :phone_number_registration
    execute "UPDATE tags set phone_number_registration_id=1"

  end

  def down
    remove_reference :tags, :phone_number_registration
  end
end
