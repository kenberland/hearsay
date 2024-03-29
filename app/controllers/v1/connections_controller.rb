class V1::ConnectionsController < ApplicationController
  before_action :confirm_logged_in, except: [:status, :login, :browse, :get_absolute_user]
  before_action :load_connection, except: [:index, :browse, :get_absolute_user]

  layout 'connections'

  def index
    @tag_categories = TagCategory.all.map &:category
  end

  def show
    @tags = get_tags(@connection.uid)
    @tag_counts = count(@connection.uid)
    @my_tags = get_my_tags(@connection.uid)
    @tag_categories = TagCategory.all.pluck(:id, :category).to_h
    render layout: false
  end

  def tag_cloud
    @tags = get_tags(@connection.uid)
    @tag_counts = count(@connection.uid)
    @my_tags = get_my_tags(@connection.uid)
    @tag_categories = TagCategory.all.pluck(:id, :category).to_h
    render :_tag_cloud, layout: false
  end

  def get_absolute_user
    @connection = User.find params[:id]
    @tags = get_tags(@connection.uid)
    @tag_counts = count(@connection.uid)
    @my_tags = current_user ? get_my_tags(@connection.uid) : []
    @tag_categories = TagCategory.all.pluck(:id, :category).to_h
    render :show, layout: false
  end

  private

  def load_connection
    index = params[:id].to_i
    return render nothing: true, status: 404 if index < 0
    @connection = Connection.new
    if index == 0
      @connection.create_from_user!(0, current_user)
    else
      @connection.create_from_index!(index, current_user)
      return render nothing: true, status: 404 if @connection.error == :out_of_range
    end
  end

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
