class UsersController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @user = api.batch do |batch_api|
      batch_api.get_object params[:id]
      batch_api.get_picture params[:id], :type => "large"
    end
  end
end
