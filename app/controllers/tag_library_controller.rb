class TagLibraryController < ApplicationController
  protect_from_forgery with: :exception

  def show
    if params[:category] == 'new-tag-form'
      render_new_tag_form
    else
      render_tag_category
    end
  end

  private

  def render_new_tag_form
    render partial: 'new_tag_form'
  end

  def render_tag_category
    @tags = Tag.joins(:tag_category).where(tag_categories: { category: params[:category] })
    @tag_category = TagCategory.find_by_category(params[:category]).category
    render layout: false
  end

end
