class User < ActiveRecord::Base
  has_many :user_tags, :foreign_key => :to_user_uid, :primary_key => :uid
  has_many :tags, through: :user_tags
#  has_many :user_taggeds, foreign_key: :from_user_uid, class_name: 'UserTag'
end
