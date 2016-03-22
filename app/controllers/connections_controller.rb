class ConnectionsController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @connection = @connections[params[:id].to_i]
    @tags = get_tags(@connection.uid)
    @tag_counts = count(@connection.uid)
    @my_tags =[]#nil#get_my_tags(@user)
    @tag_categories = TagCategory.all.pluck(:id, :category).to_h
    render layout: false
  end

  def get_tags uid
    User.find_by_uid(uid).tags.uniq rescue []
  end

  def get_my_tags user
    User.find_by_uid(user.uid).user_tags.from_user(current_user.uid).map(&:tag_id)
  end

  def count(user_id)
    UserTag.where(to_user_uid: user_id).group([:to_user_uid, :tag_id]).order('count_tag_id desc').count(:tag_id)
  end
end
