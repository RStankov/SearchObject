class PostsController < ApplicationController
  def index
    @search = PostSearch.new params[:f], params[:page]
  end
end
