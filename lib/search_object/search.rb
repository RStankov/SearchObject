module SearchObject
  class Search
    attr_reader :params

    class << self
      def build_for(config, options)
        scope   = options[:scope] || (config[:scope] && config[:scope].call)
        filters = Helper.stringify_keys(options.fetch(:filters, {}))
        params  = config[:defaults].merge Helper.slice_keys(filters, config[:actions].keys)

        raise MissingScopeError unless scope

        new scope, params, config[:actions]
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
