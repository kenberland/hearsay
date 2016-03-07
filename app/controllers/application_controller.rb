class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_connections

  def api
    @api ||= Koala::Facebook::API.new(current_user.token)
  end

  def get_connections
    @connections = Rails.cache.fetch("#{current_user.uid}/connections", expires_in: 12.hours) do
      api.get_connections('me', 'friends?fields=id,name,picture.type(large)',
                          { :limit => 5}, :batch_args => { :name => "get-friends" }
                          )
    end
  end

  def current_user= user
    session[:user_id] = user.uid
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_uid(session[:user_id])
  end

  def index
    redirect_to user_path(current_user.uid)
  end
end
