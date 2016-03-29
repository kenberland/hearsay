class UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :load_fb_profile

  def show
    @user = find_or_create_user @profile
  end

  private

  def fetch_profile
    Rails.cache.fetch("#{params[:id]}/profile", expires_in: 12.hours) do
      api.batch do |batch_api|
        batch_api.get_object params[:id]
        batch_api.get_picture params[:id], :type => "large"
      end
    end
  end

  def load_fb_profile
    @profile = {
      first_name: fetch_profile[0]['name'].split(/\s+/).first,
      last_name: fetch_profile[0]['name'].split(/\s+/).last,
      image: fetch_profile[1],
      uid: params[:id]
    }
  end

end
