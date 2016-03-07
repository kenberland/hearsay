class User < ActiveRecord::Base
  has_many :user_tags, foreign_key: :to_user_id
  has_many :tags, through: :user_tags
  has_many :user_taggeds, foreign_key: :from_user_id, class_name: 'UserTag'
end
