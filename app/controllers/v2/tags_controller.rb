class V2::TagsController < ApplicationController

  def show
    tags = Tag.joins(:tag_category).pluck(:tag, '"tag_categories"."category"')
    tag_hash = tags.each_with_object({}) do |tag, return_hash|
      return_hash[tag.last.capitalize].nil? ? return_hash[tag.last.capitalize] = [tag.first] : return_hash[tag.last.capitalize].push(tag.first)
    end

    render json: tag_hash
  end
end
