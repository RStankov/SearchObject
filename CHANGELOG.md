# Changelog

## Version 1.2.5

* __[feature]__ Added `param?` method to `Search::Base` (@rstankov)

## Version 1.2.4

* __[feature]__ Added `:with` and block support to enum (@hschne)

## Version 1.2.3

* __[fix]__ convert enum values to strings (@Postmodum37)

## Version 1.2.2

* __[feature]__ Added `SearchObject::Base#params=` method, to reset search results (@rstankov)
* __[change]__ `option :orderBy, enum: %(price date)`, now expects a method `apply_order_by_x`, instead of `apply_orderBy_with_` (__backward incompatible__) (@rstankov)

## Version 1.2.1

* __[feature]__ Added `default:` option to `sort_by` plugin (@rstankov)

```ruby
class ProductSearch
  include SearchObject.module(:sorting)

  scope { Product.all }

  sort_by :name, :price, :created_at, default: 'price asc'
end
```

## Version 1.2.0

* __[feature]__ Added `enum` plugin (@rstankov)

```ruby
class ProductSearch
  include SearchObject.module(:enum)

  scope { Product.all }

  option :order, enum: %w(popular date)

  private

  # Gets called when order with 'popular' is given
  def apply_order_with_popular(scope)
    scope.by_popularity
  end

  # Gets called when order with 'date' is given
  def apply_order_with_date(scope)
    scope.by_date
  end

  # Gets called when invalid enum is given
  def handle_invalid_order(scope, invalid_value)
    scope
  end
end
```

* __[feature]__ Scope is executed  in context of SearchObject::Base context (@rstankov)

 ```ruby
class ProductSearch
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
