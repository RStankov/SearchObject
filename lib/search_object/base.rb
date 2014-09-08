module SearchObject
  module Base
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        @defaults = {}
        @actions  = {}
        @scope    = nil
      end
    end

    def initialize(options = {})
      @search = self.class.build_internal_search options
    end

    def results
      @results ||= fetch_results
    end

    def results?
      results.any?
    end

    def count
      @count ||= @search.count self
    end

    def params(additions = {})
      if additions.empty?
        @search.params
      else
        @search.params.merge Helper.stringify_keys(additions)
      end
    end

    private

    def fetch_results
      @search.query self
    end

    module ClassMethods
      # :api: private
      def build_internal_search(options)
        scope  = options.fetch(:scope) { @scope && @scope.call } or raise MissingScopeError
        params = @defaults.merge(Helper.select_keys Helper.stringify_keys(options.fetch(:filters, {})), @actions.keys)

        Search.new scope, params, @actions
      end

      def scope(&block)
        @scope = block
      end

      def option(name, default = nil, &block)
        name = name.to_s

        @defaults[name] = default unless default.nil?
        @actions[name]  = block || ->(scope, value) { scope.where name => value unless value.blank? }

        define_method(name) { @search.param name }
      end

      def results(*args)
        new(*args).results
      end
    end
  end
end
