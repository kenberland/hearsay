class ModerationController < ApplicationController
  layout 'moderation'
  before_action :is_admin

  def index
    @tags = Tag.where(moderation_state: Tag::UNMODERATED)
  end

  def update
    result = Tag.update(params[:tag][:id], {
                          moderation_state: Tag.convert_moderation_intent(
                            params[:moderation_action])
                        })
    redirect_to :back, flash: { notice: result }
  end

  def is_admin
    redirect_to root_path unless
      ( ENV['HEARSAY_SECRET'] and
      request.headers["Hearsay-Secret"] and
        request.headers["Hearsay-Secret"] == ENV['HEARSAY_SECRET'] ) or
     ['test', 'development'].include?(Rails.env)
  end
end
