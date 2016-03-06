class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    @user = User.find_or_create_by({ uid: auth_hash.uid,
                                     first_name: auth_hash.info.first_name,
                                     last_name:  auth_hash.info.last_name,
                                     image:      auth_hash.info.image,
                                     token:      auth_hash.credentials.token,
                                     secret:     auth_hash.credentials.secret,
                                   })

    self.current_user = @user
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
