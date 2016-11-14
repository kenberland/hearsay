class UserTag < ActiveRecord::Base
  enum notification_state: [:in_progress, :notified]
  has_one :tag, foreign_key: :id, :primary_key => :tag_id
end
