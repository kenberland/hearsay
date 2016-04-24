class TagsController < ApplicationController
  protect_from_forgery with: :exception
  before_action :prevent_tagging_self, only: :create

  def create
    new_tag = Tag.find params[:tag][:id]
    new_user_tag = User.find_by(uid: params[:user_id]).user_tags.build tag_id: new_tag.id, from_user_uid: current_user.uid
    begin
      new_user_tag.save
    rescue PG::UniqueViolation => e
      Rails.logger.error e
    end
    redirect_to tag_cloud_connection_path(params[:users][:index]), status: 303
  end

  def destroy
    UserTag.find_by(tag_id: params[:id], from_user_uid: current_user.uid, to_user_uid: params[:user_id]).destroy rescue nil
    redirect_to tag_cloud_connection_path(params[:users][:index]), status: 303
  end

  private

  def prevent_tagging_self
    toaster_json = {
      'message' => I18n.t('errors.self-tagging'),
      'priority' => 'warning'
    }.to_json
    return render js: "$.toaster(#{toaster_json});", status: 400
  end
end
