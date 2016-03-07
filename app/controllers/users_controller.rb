class UsersController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @profile = get_fb_profile
    @tags = get_tags
  end

  private

  def get_tags
    current_user.tags
  end

  def get_fb_profile
    Rails.cache.fetch("#{params[:id]}/profile", expires_in: 12.hours) do
      api.batch do |batch_api|
        batch_api.get_object params[:id]
        batch_api.get_picture params[:id], :type => "large"
      end
    end
  end

end
