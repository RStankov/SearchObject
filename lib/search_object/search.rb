module SearchObject
  class Search
    attr_reader :params

    class << self
      def build_for(scope:, actions:, defaults:, filters:)
        raise MissingScopeError unless scope

        params = defaults.merge(
          Helper.slice_keys(Helper.stringify_keys(filters), actions.keys)
        )

        new scope, params, actions
      end
    end

    def initialize(scope, params, actions)
      @scope    = scope
      @actions  = actions
      @params   = params
    end

    def param(name)
      @params[name]
    end

    def query(context)
      @params.inject(@scope) do |scope, (name, value)|
        new_scope = context.instance_exec scope, value, &@actions[name]
        new_scope || scope
      end
    end

    def count(context)
      query(context).count
    end
  end
end
