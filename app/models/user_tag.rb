class UserTag < ActiveRecord::Base
  has_one :tag, foreign_key: :id, :primary_key => :tag_id
end
