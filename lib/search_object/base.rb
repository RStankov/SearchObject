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
        params = @defaults.merge Helper.select_keys(Helper.stringify_keys(options.fetch(:filters, {})), @actions.keys)

        Search.new scope, params, @actions
      end

      def scope(&block)
        @scope = block
      end

      def option(name, options = nil, &block)
        options = {default: options} unless options.is_a?(Hash)

        name = name.to_s
        default = options[:default]
        handler = options[:with] || block

        @defaults[name] = default unless default.nil?
        @actions[name]  = _normalize_search_object_handler(handler, name)

        define_method(name) { @search.param name }
      end

      def results(*args)
        new(*args).results
      end

      private

      def _normalize_search_object_handler(handler, name)
        case handler
        when Symbol
          ->(scope, value) { method(handler).call scope, value }
        when Proc
          handler
        else
          ->(scope, value) { scope.where name => value unless value.blank? }
        end
      end
    end
  end
end
