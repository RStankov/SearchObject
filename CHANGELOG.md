# Changelog

## Version 1.0

* Added min_per_page and max_per_page to paging plugin

* Default paging behaves more like 'kaminari' and 'will_paginate' by treating 1 page as 0 index (__backward incompatible__)

* Raise `SearchObject::MissingScopeError` when no scope is provided

* Replace position arguments with Hash of options (__backward incompatible__)

  ```diff
  - Search.new params[:f], params[:page]
  + Search.new filters: params[:f], page: params[:page]
  ```

## Version 0.2

* Added `.results` shortcut for `new(*arg).results`

* Fix wrong limit and offset in default paging

## Version 0.1

* Initial release
