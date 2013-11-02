class PostSearch
  include SearchObject.module(:model, :sorting, :will_paginate)

  scope { Post.all }

  sort_by :created_at, :views_count, :likes_count, :comments_count

  option :user_id
  option :category_name

  option :title do |scope, value|
    scope.where 'title LIKE ?', "%#{value.gsub(/\s+/, '%')}%"
  end

  option :published do |scope, value|
    scope.where published: true if value.present?
  end

  def per_page
    25
  end
end
