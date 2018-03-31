class Tag < ActiveRecord::Base
  UNMODERATED = 0
  APPROVED = 1
  REJECTED = 2

  belongs_to :tag_category, class_name: 'TagCategory'
  validates :tag, presence: true
  validates :tag, length: { minimum: 2, maximum: 24 }

  def is_unmoderated
    self.moderation_state == UNMODERATED
  end

  def is_approved
    self.moderation_state == APPROVED
  end

  def is_rejected
    self.moderation_state == REJECTED
  end

  def moderation_text
    case self.moderation_state
    when UNMODERATED
      'unmoderated'
    when APPROVED
      'approved'
    else
      'rejected'
    end
  end

  def self.convert_moderation_intent intent
    case intent
    when 'approve'
      APPROVED
    else
      REJECTED
    end
  end
end
