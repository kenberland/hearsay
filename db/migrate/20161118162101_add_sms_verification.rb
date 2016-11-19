class AddSmsVerification < ActiveRecord::Migration
  def change
    add_column :phone_number_registrations, :verification_state, :integer, { default: 0 }
    add_column :phone_number_registrations, :verification_code, :string
  end
end
