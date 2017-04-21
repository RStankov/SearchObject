module SearchObject
  # :api: private
  class Search
    attr_reader :params

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
