class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def confirm_logged_in
    redirect_to root_path unless current_user
  end

  def current_user
    params[:currentUser]
  end

  def status
    render json: {status: 'OK'}.merge(ActiveRecord::Base.connection.execute('SELECT "now", now()').to_h)
  end
end
