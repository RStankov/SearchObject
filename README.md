[![Gem Version](https://badge.fury.io/rb/search_object.svg)](http://badge.fury.io/rb/search_object)
[![Code Climate](https://codeclimate.com/github/RStankov/SearchObject.svg)](https://codeclimate.com/github/RStankov/SearchObject)
[![Build Status](https://secure.travis-ci.org/RStankov/SearchObject.svg)](http://travis-ci.org/RStankov/SearchObject)
[![Code coverage](https://coveralls.io/repos/RStankov/SearchObject/badge.svg?branch=master)](https://coveralls.io/r/RStankov/SearchObject)

# SearchObject

In many of my projects I needed an object that performs several fairly complicated queries. Most times I hand-coded them, but they would get complicated over time when other concerns like sorting, pagination and so are being added. So I decided to abstract this away and created ```SearchObject```, a DSL for creating such objects.

It is useful for:

- complicated search forms
- api endpoints with multiple filter conditions
- [GraphQL](https://rmosolgo.github.io/graphql-ruby/) resolvers
- ... search objects 😀

## Table of Contents

* [Installation](#installation)
* [Dependencies](#dependencies)
* [Usage](#usage)
  * [Example](#example)
* [Plugins](#plugins)
  * [Paginate Plugin](#paginate-plugin)
  * [Enum Plugin](#enum-plugin)
  * [Model Plugin](#model-plugin)
  * [GraphQL Plugin](#graphql-plugin)
  * [Sorting Plugin](#sorting-plugin)
* [Tips & Tricks](#tips--tricks)
    * [Results Shortcut](#results-shortcut)
    * [Passing Scope as Argument](#passing-scope-as-argument)
    * [Handling Nil Options](#handling-nil-options)
    * [Default Option Block](#default-option-block)
    * [Using Instance Method in Option Blocks](#using-instance-method-in-option-blocks)
    * [Using Instance Method for Straight Dispatch](#using-instance-method-for-straight-dispatch)
    * [Active Record Is Not Required](#active-record-is-not-required)
    * [Overwriting Methods](#overwriting-methods)
    * [Extracting Basic Module](#extracting-basic-module#)
* [Contributing](#contributing)
* [License](#license)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'search_object'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install search_object

## Usage

Just include the ```SearchObject.module``` and define your search options:

```ruby
class PostSearch
  include SearchObject.module

  # Use .all (Rails4) or .scoped (Rails3) for ActiveRecord objects
  scope { Post.all }

  option(:name)             { |scope, value| scope.where name: value }
  option(:created_at)       { |scope, dates| scope.created_after dates }
  option(:published, false) { |scope, value| value ? scope.unopened : scope.opened }
end
```

Then you can just search the given scope:

```ruby
search = PostSearch.new(filters: params[:filters])

# accessing search options
search.name                        # => name option
search.created_at                  # => created at option

# accessing results
search.count                       # => number of found results
search.results?                    # => is there any results found
search.results                     # => found results

# params for url generations
search.params                      # => option values
search.params opened: false        # => overwrites the 'opened' option
```

### Example

You can find example of most important features and plugins - [here](https://github.com/RStankov/SearchObject/tree/master/example).

## Plugins

```SearchObject``` support plugins, which are passed to ```SearchObject.module``` method.

Plugins are just plain Ruby modules, which are included with ```SearchObject.module```. They are located under ```SearchObject::Plugin``` module.

### Paginate Plugin

Really simple paginate plugin, which uses the plain ```.limit``` and ```.offset``` methods.

```ruby
class ProductSearch
  include SearchObject.module(:paging)

  scope { Product.all }

  option :name
  option :category_name

  # per page defaults to 10
  per_page 10

  # range of values is also possible
  min_per_page 5
  max_per_page 100
end

search = ProductSearch.new(filters: params[:filters], page: params[:page], per_page: params[:per_page])

search.page                                                 # => page number
search.per_page                                             # => per page (10)
search.results                                              # => paginated page results
```

Of course if you want more sophisticated pagination plugins you can use:

```ruby
include SearchObject.module(:will_paginate)
include SearchObject.module(:kaminari)
```

### Enum Plugin

Gives you filter with pre-defined options.

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

  # (optional) Gets called when invalid enum is given
  def handle_invalid_order(scope, invalid_value)
    scope
  end
end
```

### Model Plugin

Extends your search object with ```ActiveModel```, so you can use it in Rails forms.

```ruby
class ProductSearch
  include SearchObject.module(:model)

  scope { Product.all }

  option :name
  option :category_name
end
```

```erb
<%# in some view: %>

<%= form_for ProductSearch.new do |form| %>
  <% form.label :name %>
  <% form.text_field :name %>
  <% form.label :category_name %>
  <% form.text_field :category_name %>
<% end %>
```

### GraphQL Plugin

Installed as separate [gem](https://github.com/RStankov/SearchObjectGraphQL), it is designed to work with GraphQL:

```
gem 'search_object_graphql'
```

```ruby
class PostResolver
  include SearchObject.module(:graphql)

  type PostType

  scope { Post.all }

  option(:name, type: types.String)       { |scope, value| scope.where name: value }
  option(:published, type: types.Boolean) { |scope, value| value ? scope.published : scope.unpublished }
end
```

### Sorting Plugin

Fixing the pain of dealing with sorting attributes and directions.

```ruby
class ProductSearch
  include SearchObject.module(:sorting)

  scope { Product.all }

  sort_by :name, :price
end

search = ProductSearch.new(filters: {sort: 'price desc'})

search.results                                # => Product sorted my price DESC
search.sort_attribute                         # => 'price'
search.sort_direction                         # => 'desc'

# Smart sort checking
search.sort?('price')                         # => true
search.sort?('price desc')                    # => true
search.sort?('price asc')                     # => false

# Helpers for dealing with reversing sort direction
search.reverted_sort_direction                # => 'asc'
search.sort_direction_for('price')            # => 'asc'
search.sort_direction_for('name')             # => 'desc'

# Params for sorting links
search.sort_params_for('name')

```

## Tips & Tricks

### Results Shortcut

Very often you will just need results of search:

```ruby
ProductSearch.new(params).results == ProductSearch.results(params)
```

### Passing Scope as Argument

``` ruby
class ProductSearch
  include SearchObject.module
end

# first arguments is treated as scope (if no scope option is provided)
search = ProductSearch.new(scope: Product.visible, filters: params[:f])
search.results # => includes only visible products
```

### Handling Nil Options

```ruby
class ProductSearch
  include SearchObject.module

  scope { Product.all }

  # nil values returned from option blocks are ignored
  option(:sold) { |scope, value| scope.sold if value }
end
```

### Default Option Block

```ruby
class ProductSearch
  include SearchObject.module

  scope { Product.all }

  option :name # automaticly applies => { |scope, value| scope.where name: value unless value.blank? }
end
```

### Using Instance Method in Option Blocks

```ruby
class ProductSearch
  include SearchObject.module

  scope { Product.all }

  option(:date) { |scope, value| scope.by_date parse_dates(value) }

  private

  def parse_dates(date_string)
    # some "magic" method to parse dates
  end
end
```

### Using Instance Method for Straight Dispatch

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

### Active Record Is Not Required

```ruby
class ProductSearch
  include SearchObject.module

  scope { RemoteEndpoint.fetch_product_as_hashes }

  option(:name)     { |scope, value| scope.select { |product| product[:name] == value } }
  option(:category) { |scope, value| scope.select { |product| product[:category] == value } }
end
```

### Overwriting Methods

You can have fine grained scope, by overwriting ```initialize``` method:

```ruby
class ProductSearch
  include SearchObject.module

  option :name
  option :category_name

  def initialize(user, options = {})
    super options.merge(scope: Product.visible_to(user))
  end
end
```

Or you can add simple pagination by overwriting both ```initialize``` and ```fetch_results``` (used for fetching results):

```ruby
class ProductSearch
  include SearchObject.module

  scope { Product.all }

  option :name
  option :category_name

  attr_reader :page

  def initialize(filters = {}, page = 0)
    super filters
    @page = page.to_i.abs
  end

  def fetch_results
    super.paginate page: @page
  end
end
```

### Extracting Basic Module

You can extarct a basic search class for your application.

```ruby
class BaseSearch
  include SearchObject.module

  # ... options and configuration
end
```

 Then use it like:

 ```ruby
class ProductSearch < BaseSearch
  scope { Product }
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Run the tests (`rake`)
6. Create new Pull Request

## License

**[MIT License](https://github.com/RStankov/SearchObject/blob/master/LICENSE.txt)**
