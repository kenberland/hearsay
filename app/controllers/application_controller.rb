class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user= user
      session[:user_id] = user.uid
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_uid(session[:user_id])
  end

  def index
    client = LinkedIn::Client.new
    client.authorize_from_access(current_user.token, current_user.secret)
    @connections = client.connections
  end

end
