class V1::TagLibraryController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @tags = Tag.joins(:tag_category).where(tag_categories: { category: params[:category] })
    @tag_category = TagCategory.find_by_category(params[:category]).category
    render layout: false
  end

  def create
    tc = TagCategory.find_by_category params[:tag_library_category]
    Tag.find_or_create_by({ tag: params[:tag], tag_category: tc }) rescue PG::UniqueViolation
    redirect_to tag_library_path(params[:tag_library_category]), status: 303
  end
end
