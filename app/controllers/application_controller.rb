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
    @api = Koala::Facebook::API.new(current_user.token)
    @connections = @api.get_connections('me', 'friends?fields=id,name,picture.type(large)', 
                                        { :limit => 5}, :batch_args => { :name => "get-friends" }
                                        )
  end
end
