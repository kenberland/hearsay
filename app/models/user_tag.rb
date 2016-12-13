class UserTag < ActiveRecord::Base
  audited
  acts_as_paranoid
  before_destroy :reset_notification_state
  enum notification_state: [:in_progress, :notified]
  has_one :tag, foreign_key: :id, :primary_key => :tag_id
  def reset_notification_state
    self.notification_state = nil
    self.save
  end
end
