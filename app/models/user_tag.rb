class UserTag < ActiveRecord::Base
  audited
  acts_as_paranoid
  has_one :tag, foreign_key: :id, :primary_key => :tag_id
end
