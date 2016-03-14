class TagLibraryController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @tags = Tag.joins(:tag_category).where(tag_categories: { category: params[:category] })
    @tag_category = TagCategory.find_by_category(params[:category]).category
    render layout: false
  end

end
