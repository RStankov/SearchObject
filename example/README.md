# SearchObject example Rails application

This is example application showing, one of the possible usages of ```SearchObject```. It showcases the following features:

  * Basic search object functionality
  * Default options
  * Using private method helpers in options
  * Plugins: model, sorting, will_paginate

## Installation

```
gem install bundler
bundle install
rake db:create
rake db:migrate
rake db:seed

rails server
```

From there just visit: [localhost:3000/](http://localhost:3000/)


## Screenshot

![Screenshot](https://raw.github.com/RStankov/SearchObject/master/example/screenshot.png)
