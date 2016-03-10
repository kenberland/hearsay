class ConnectionsController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @connection = @connections[params[:id].to_i]
    @tags = get_tags(@connection.uid)
    @my_tags =[]#nil#get_my_tags(@user)
    render layout: false
  end

end
