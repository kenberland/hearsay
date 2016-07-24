class V2::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    User.create(phone_number: params[:phoneNumber], first_name: params[:name])
  end
end
