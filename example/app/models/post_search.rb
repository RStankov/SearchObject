class PostSearch
  include SearchObject.module

  scope { Post.all }
end
