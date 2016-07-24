class AddPhoneNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string, { limit: 255 }
  end
end
