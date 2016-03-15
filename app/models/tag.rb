class Tag < ActiveRecord::Base
  belongs_to :tag_category, class_name: 'TagCategory'


  def count(user_id)
    UserTag.where(tag_id: id).where(to_user_uid: user_id).group([:to_user_uid, :tag_id]).count(:tag_id).values.first
  end
end
