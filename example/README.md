# SearchObject Example Rails Application

This is example application showing, one of the possible usages of ```SearchObject```. It showcases the following features:

  * Basic search object functionality
  * Default options
  * Using private method helpers in options
  * Plugins: model, sorting, will_paginate, enum

## Interesting files:

  * [PostsController](https://github.com/RStankov/SearchObject/blob/master/example/app/controllers/posts_controller.rb)
  * [PostSearch](https://github.com/RStankov/SearchObject/blob/master/example/app/models/post_search.rb)
  * [posts/index.html.slim](https://github.com/RStankov/SearchObject/blob/master/example/app/views/posts/index.html.slim)
  * [PostSearch spec](https://github.com/RStankov/SearchObject/blob/master/example/spec/models/post_search_spec.rb)

## Installation

```
gem install bundler
bundle install
rails db:create
rails db:migrate
rails db:seed

rails server
```

From there just visit: [localhost:3000/](http://localhost:3000/)


## Screenshot

![Screenshot](https://raw.github.com/RStankov/SearchObject/master/example/screenshot.png)
