class PostsController < ApplicationController
  def index
    @search = PostSearch.new params[:f]
  end
end
