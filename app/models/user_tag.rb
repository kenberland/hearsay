class UserTag < ActiveRecord::Base
#  has_one :tag, primary_key: :tag_id
  has_one :tag, foreign_key: :id, :primary_key => :tag_id
 # belongs_to :user, foreign_key: :to_user_uid
#  belongs_to :user, :primary_key => :foo
end
