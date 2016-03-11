class TagLibraryController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @tags = Tag.joins(:tag_category).where(tag_categories: { category: params[:id] })
    render layout: false
  end

end
