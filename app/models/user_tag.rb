class UserTag < ActiveRecord::Base
  has_one :tag, foreign_key: :id
end
