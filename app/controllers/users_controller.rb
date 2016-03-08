class UsersController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @profile = get_fb_profile
    @user = find_or_create_user @profile
    @tags = get_tags(@user)
    @my_tags = get_my_tags(@user)
  end

  private

  def find_or_create_user attr
    User.find_or_create_by(trim_hash(attr))
  end

  def trim_hash attr
    attr.slice(:uid, :first_name, :last_name)
  end

  def get_tags user
    User.find_by_uid(user.uid).tags rescue []
  end

  def get_my_tags user
    User.find_by_uid(user.uid).user_tags.from_user(current_user.uid).map &:tag_id
  end

  def fetch_profile
    Rails.cache.fetch("#{params[:id]}/profile", expires_in: 12.hours) do
      api.batch do |batch_api|
        batch_api.get_object params[:id]
        batch_api.get_picture params[:id], :type => "large"
      end
    end
  end

  def get_fb_profile
    {
      first_name: fetch_profile[0]['name'].split(/\s+/).first,
      last_name: fetch_profile[0]['name'].split(/\s+/).last,
      image: fetch_profile[1],
      uid: params[:id]
    }
  end

end
