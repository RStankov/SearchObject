class PostsController < ApplicationController
  def index
    @search = PostSearch.new
  end
end
