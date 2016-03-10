class ConnectionsController < ApplicationController
  protect_from_forgery with: :exception
#  before_action :load_fb_profile
#  before_action :load_user

  def show
    render layout: false
  end

end
