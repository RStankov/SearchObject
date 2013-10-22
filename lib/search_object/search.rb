module SearchObject
  module Search
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        @defaults = {}
        @actions  = {}
        @scope    = {}
      end
    end

    def initialize(filters = {})
      @filters = self.class.select_filters Helper.stringify_keys(filters)
    end

    def results
      @results ||= fetch_results
    end

    def results?
      results.any?
    end

    def params(additions = {})
      @filters.merge Helper.stringify_keys(additions)
    end

    private

    def fetch_results
      self.class.fetch_results_for self
    end


    module ClassMethods
      def select_filters(filters)
        Helper.select_keys filters, @actions.keys
      end

      def fetch_results_for(search)
        @defaults.merge(search.params).inject(@scope.call) do |scope, (name, value)|
          search.instance_exec scope, value, &@actions[name]
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
