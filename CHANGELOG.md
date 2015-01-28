# Changelog

## Version 1.0.1 (Unreleased)

* Search objects now can be inherited

 ```ruby
 class BaseSearch
   include SearchObject.module

   # ... options and configuration
 end

 class ProductSearch < BaseSearch
   scope { Product }
 end
 ```

* Using instance method for straight dispatch

  ```ruby
  class ProductSearch
    include SearchObject.module

    scope { Product.all }

    option :name
    option :category_name

    attr_reader :page

    def initialize(filters = {}, page = 0)
      super filters
      @page = page.to_i.abc
    end

    def fetch_results
      super.paginate page: @page
    end
  end
  ```

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
