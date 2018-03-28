class Tag < ActiveRecord::Base
  UNMODERATED = 0
  APPROVED = 1
  REJECTED = 2

  belongs_to :tag_category, class_name: 'TagCategory'
  validates :tag, presence: true
  validates :tag, length: { minimum: 2, maximum: 24 }
  def isNew
    self.moderation_state == UNMODERATED
  end

  def isApproved
    self.moderation_state == APPROVED
  end

  def isRejected
    self.moderation_state == REJECTED
  end
end
