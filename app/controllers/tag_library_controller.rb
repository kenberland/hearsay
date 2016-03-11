class TagLibraryController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @tags = Tag.all
    render layout: false
  end

end
