class ConnectionsController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @connection = @connections[params[:id].to_i]
    @tags = get_tags(@connection.uid)
    @my_tags =[]#nil#get_my_tags(@user)
    render layout: false
  end

  def get_tags uid
    User.find_by_uid(uid).tags rescue []
  end

  def get_my_tags user
    User.find_by_uid(user.uid).user_tags.from_user(current_user.uid).map &:tag_id
  end
end
