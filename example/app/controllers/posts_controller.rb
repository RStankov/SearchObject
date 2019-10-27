# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @search = PostSearch.new filters: params[:f], page: params[:page], per_page: params[:per_page]
  end
end
