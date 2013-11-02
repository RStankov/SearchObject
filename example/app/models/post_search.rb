class PostSearch
  include SearchObject.module(:will_paginate)

  scope { Post.scoped }

  def per_page
    25
  end
end
