class AddNotificationStatusToUsertags < ActiveRecord::Migration
  def change
    add_column :user_tags, :notification_state, :integer
  end
end
