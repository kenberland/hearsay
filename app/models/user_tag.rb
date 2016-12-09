class UserTag < ActiveRecord::Base
  audited
  acts_as_paranoid
  enum notification_state: [:in_progress, :notified]
  has_one :tag, foreign_key: :id, :primary_key => :tag_id
end
