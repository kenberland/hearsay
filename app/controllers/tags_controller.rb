class TagsController < ApplicationController
  protect_from_forgery with: :exception
  before_action :prevent_tagging_self, only: :create

  def create
    new_tag = Tag.find params[:tag][:id]
    new_user_tag = User.find_by(uid: params[:user_id]).user_tags.build tag_id: new_tag.id, from_user_uid: current_user.uid
    new_user_tag.save rescue PG::UniqueViolation
    redirect_to connection_tag_cloud_path(params[:user_id])
  end

  def destroy
    UserTag.find_by(tag_id: params[:id], from_user_uid: current_user.uid, to_user_uid: params[:user_id]).destroy rescue nil
    render json: {}
  end

  private

  def prevent_tagging_self
    redirect_to :back, :flash => { :error => I18n.t('errors.self-tagging') } and return if params[:user_id].to_i == current_user.uid
  end
end
