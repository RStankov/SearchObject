# Changelog

## Version 1.2.0 (unreleased)

* __[feature]__ Scope is executed  in context of SearchObject::Base context (@rstankov)

 ```ruby
class ProductSearch < BaseSearch
  include SearchObject.module

  scope { @shop.products }

  def initialize(shop)
    @shop = shop
    super
  end
end
```

## Version 1.1.3

* __[feature]__ Passing nil as `scope` in constructor, falls back to default scope (@rstankov)

## Version 1.1.2

* __[fix]__ Fix a warning due to Rails 5 `ActionController::Parameters` not being a Hash (@rstankov)
* __[fix]__ Ensure `sort_by` prefixes with table_name. (@andreasklinger)

## Version 1.1.1

* __[fix]__ Fix a bug in inheriting search objects (@avlazarov)

## Version 1.1

* __[feature]__ Search objects now can be inherited  (@rstankov)

 ```ruby
 class BaseSearch
   include SearchObject.module

   # ... options and configuration
 end

 class ProductSearch < BaseSearch
   scope { Product }
 end
 ```

* __[feature]__ Use instance method for straight dispatch (@gsamokovarov)

  ```ruby
  class ProductSearch
    include SearchObject.module

    scope { Product.all }

    option :date, with: :parse_dates

    private

    def parse_dates(scope, value)
      # some "magic" method to parse dates
    end
  end
  ```

## Version 1.0

* __[feature]__ Added min_per_page and max_per_page to paging plugin (@rstankov)

* __[change]__ Default paging behaves more like 'kaminari' and 'will_paginate' by treating 1 page as 0 index (__backward incompatible__) (@rstankov)

* __[feature]__ Raise `SearchObject::MissingScopeError` when no scope is provided (@rstankov)

* __[change]__ Replace position arguments with Hash of options (__backward incompatible__) (@rstankov)

  ```diff
  - Search.new params[:f], params[:page]
  + Search.new filters: params[:f], page: params[:page]
  ```

## Version 0.2

* __[feature]__ Added `.results` shortcut for `new(*arg).results` (@rstankov)

* __[fix]__ Fix wrong limit and offset in default paging (@rstankov)

## Version 0.1

* Initial release (@rstankov)
