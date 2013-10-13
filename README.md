# SearchObject

Provides DSL for creating search objects

## Installation

Add this line to your application's Gemfile:

    gem 'search_object'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install search_object

## Usage

Just include the ```SearchObject.module``` and define your search options:

```ruby
class MessageSearch
  include SearchObject.module

  scope { Message }

  option :name          { |scope, value| scope.where :name => value }
  option :created_at    { |scope, dates| scope.created_between(dates)}
  option :opened, false { |scope, value| value ? scope.unopened : scope.opened }
end
```

Then you can just search the messages scope:

```ruby
search = MessageSearch.new(params[:filters])

# accessing option values
search.name                        # => name option
search.created_at                  # => created at option

# accessing results
search.count                       # => number of results found
search.results?                    # => is there any results found
search.results                     # => results found

# params for url generations
search.params                     # => returns the option values
search.params(:opened => false)   # => overwrites the 'opened' option
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
