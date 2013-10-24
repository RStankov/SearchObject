module SearchObject
  module Search
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        @defaults = {}
        @actions  = {}
        @scope    = nil
      end
    end

    def initialize(*args)
      @scope, @filters = self.class.scope_and_filters(args)
    end

    def results
      @results ||= fetch_results
    end

    def results?
      results.any?
    end

    def count
      @count ||= _fetch_results.count
    end

    def params(additions = {})
      if additions.empty?
        @filters
      else
        @filters.merge Helper.stringify_keys(additions)
      end
    end

    private

    def fetch_results
      _fetch_results
    end

    def _fetch_results
      self.class.fetch_results_for @scope, self
    end

    module ClassMethods
      def scope_and_filters(args)
        scope   = (@scope && @scope.call) || args.shift
        filters = Helper.select_keys Helper.stringify_keys(args.shift || {}), @actions.keys
        [scope, filters]
      end

      def fetch_results_for(scope, search)
        @defaults.merge(search.params).inject(scope) do |scope, (name, value)|
          new_scope = search.instance_exec scope, value, &@actions[name]
          new_scope || scope
        end
      end

      def scope(&block)
        @scope = block
      end

      def option(name, default = nil, &block)
        name = name.to_s

        @defaults[name] = default unless default.nil?
        @actions[name]  = block || ->(scope, value) { scope.where name => value }

        define_method(name) { @filters.has_key?(name) ? @filters[name] : default }
      end
    end
  end
end
