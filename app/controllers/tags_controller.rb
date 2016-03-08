class TagsController < ApplicationController
  protect_from_forgery with: :exception

  def create
    redirect_to :back, :flash => { :error => I18n.t('errors.self-tagging') } and return if params[:user_id].to_i == current_user.uid
    new_tag = Tag.find_or_create_by (tag_params)
    new_user_tag = User.find_by(uid: params[:user_id]).user_tags.build tag_id: new_tag.id, from_user_uid: current_user.uid
    new_user_tag.save rescue PG::UniqueViolation
    redirect_to :back
  end

  private

  def tag_params
    {tag: params[:tag][:tag]}
  end

end
