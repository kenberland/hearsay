class User < ActiveRecord::Base
  has_many :user_tags, :foreign_key => :to_user_uid, :primary_key => :uid do
    def from_user(uid)
      where(from_user_uid: uid)
    end
  end
  has_many :tags, through: :user_tags
end
