# frozen_string_literal: true

module SearchObject
  # :api: private
  class Search
    attr_reader :params

    def initialize(scope:, options: nil, defaults: nil, params: nil)
      @scope = scope
      @options = options || {}
      @defaults = defaults || {}

      self.params = params
    end

    def params=(params)
      @params = @defaults.merge(Helper.slice_keys(Helper.stringify_keys(params || {}), @options.keys))
    end

    def param(name)
      @params[name.to_s]
    end

    def query(context)
      @params.inject(@scope) do |scope, (name, value)|
        new_scope = context.instance_exec scope, value, &@options[name]
        new_scope || scope
      end
    end

    def count(context)
      query(context).count
    end
  end
end
