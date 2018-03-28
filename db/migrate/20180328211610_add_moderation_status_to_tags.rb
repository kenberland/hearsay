class AddModerationStatusToTags < ActiveRecord::Migration
  def change
    add_column :tags, :moderation_state, :integer, default: 0
  end
end
