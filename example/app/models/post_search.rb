class PostSearch
  include SearchObject.module(:sorting, :will_paginate)

  scope { Post.all }

  sort_by :created_at, :views_count, :likes_count, :comments_count

  def per_page
    25
  end
end
