class ModerationController < ApplicationController
  layout 'moderation'
  before_action :is_admin

  def index
    @tags = Tag.where(moderation_state: Tag::UNMODERATED)
  end

  def update
  end

  def is_admin
    redirect_to root_path unless
      ( ENV['HEARSAY_SECRET'] and
      request.headers["Hearsay-Secret"] and
        request.headers["Hearsay-Secret"] == ENV['HEARSAY_SECRET'] ) or
     ['test'].include?(Rails.env)
  end
end
