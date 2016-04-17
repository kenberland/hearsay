class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :get_connections

  def create
    @user = User.find_or_create_by({ uid: auth_hash.uid })
    @user.update_attributes({
                              first_name: auth_hash.info.first_name,
                              last_name:  auth_hash.info.last_name,
                              image:      auth_hash.info.image,
                              token:      auth_hash.credentials.token,
                              secret:     auth_hash.credentials.secret,
                            })
    self.current_user = @user
    render json: { success: true, location: connections_path }.to_json, :status => 200
  end

  protected

  def split_name name
    name.split(/\s+/)
  end

  def omni_hash
    request.env['omniauth.auth']
  end

  def auth_hash
    if omni_hash.info.first_name.blank? and omni_hash.info.last_name.blank?
      omni_hash.info.first_name = split_name(omni_hash.info.name).first
      omni_hash.info.last_name = split_name(omni_hash.info.name).last
    end
    omni_hash
  end
end
