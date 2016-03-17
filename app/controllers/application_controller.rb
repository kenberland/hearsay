class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_connections, except: :status
  before_action :get_tag_categories, except: :status

  def api
    @api ||= Koala::Facebook::API.new(current_user.token)
  end

  def get_connections
    @connections = Rails.cache.fetch("#{current_user.uid}/connections", expires_in: 10.minutes) do
      Connections.new fetch_connections
    end
  end

  def get_tag_categories
    @tag_categories = TagCategory.all.map &:category
  end

  def current_user= user
    session[:user_id] = user.uid
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_uid(session[:user_id])
  end

  def index
  end

  def status
    ActiveRecord::Base.connection.execute('SELECT now()')
    render json: {status: 'OK'}.merge(ActiveRecord::Base.connection.execute('SELECT NOW()').first).to_json
  end

  private

  def fetch_connections
    api.get_connections('me', 'friends?fields=id,name,picture.type(large),first_name,last_name',
                        { :limit => 5}, :batch_args => { :name => "get-friends" }
                        )
  end

  def get_tags uid
    User.find_by_uid(uid).tags rescue []
  end

  def get_my_tags user
    User.find_by_uid(user.uid).user_tags.from_user(current_user.uid).map &:tag_id
  end

  def fetch_profile
    Rails.cache.fetch("#{params[:id]}/profile", expires_in: 12.hours) do
      api.batch do |batch_api|
        batch_api.get_object params[:id]
        batch_api.get_picture params[:id], :type => "large"
      end
    end
  end

  def load_user
    @user = find_or_create_user @profile
  end

  def load_fb_profile
    @profile = {
      first_name: fetch_profile[0]['name'].split(/\s+/).first,
      last_name: fetch_profile[0]['name'].split(/\s+/).last,
      image: fetch_profile[1],
      uid: params[:id]
    }
  end

end
