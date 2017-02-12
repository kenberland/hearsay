class Tag < ActiveRecord::Base
  belongs_to :tag_category, class_name: 'TagCategory'
  validates :tag, presence: true
  validates :tag, length: { minimum: 2, maximum: 24 }
end
