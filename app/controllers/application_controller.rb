class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def api
    @api ||= Koala::Facebook::API.new(current_user.token)
  end

  def get_connections
    @connections = Connections.new current_user
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

  def status
    ActiveRecord::Base.connection.execute('SELECT now()')
    render json: {status: 'OK'}.merge(ActiveRecord::Base.connection.execute('SELECT NOW()').first).to_json
  end
end
