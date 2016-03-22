class Tag < ActiveRecord::Base
  belongs_to :tag_category, class_name: 'TagCategory'

#  default_scope: 
end
