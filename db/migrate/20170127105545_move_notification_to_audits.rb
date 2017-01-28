class MoveNotificationToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :notification_state, :integer
    add_index :audits, :notification_state, :name => 'audits_notification_state_index'
    remove_column :user_tags, :notification_state
  end
end
