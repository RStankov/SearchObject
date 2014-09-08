class PostsController < ApplicationController
  def index
    @search = PostSearch.new filters: params[:f], page: params[:page]
  end
end
