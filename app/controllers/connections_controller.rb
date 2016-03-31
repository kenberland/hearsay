class ConnectionsController < ApplicationController
  before_action :confirm_logged_in, except: [:status, :login]

  def index
    @tag_categories = TagCategory.all.map &:category
  end

  def show
    @connection = Connection.new(params[:id], current_user)
    @tags = []
    @my_tags = []
    @tag_counts = []
    @tag_categories = TagCategory.all.pluck(:id, :category).to_h
    render layout: false
  end

  def tag_cloud
    params[:id] = params[:connection_id]
    @connection = [] #@connections.find_by_uid(params[:id])
    @tags = [] #get_tags(@connection.uid)
    @tag_counts = {} #count(@connection.uid)
    @my_tags = [] #get_my_tags(@connection.uid)
    @tag_categories = TagCategory.all.pluck(:id, :category).to_h
    render :_tag_cloud, layout: false
  end

  private

  def get_tags uid
    User.find_by_uid(uid).tags.uniq rescue []
  end

  def get_my_tags connection_uid
    User.find_by_uid(connection_uid).user_tags.from_user(current_user.uid).map(&:tag_id)
  end

  def count(user_id)
    UserTag.where(to_user_uid: user_id).group([:to_user_uid, :tag_id]).order('count_tag_id desc').count(:tag_id)
  end
end
