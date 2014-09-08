# Changelog

## Version 1.0 (unreleased)

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
