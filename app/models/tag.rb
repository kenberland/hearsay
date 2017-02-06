class Tag < ActiveRecord::Base
  belongs_to :tag_category, class_name: 'TagCategory'
  validates :tag, presence: true
end
