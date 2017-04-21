module SearchObject
  module Base
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        @config = {
          defaults:  {},
          actions:   {},
          scope:     nil
        }
      end
    end

    def initialize(options = {})
      config = self.class.config
      scope = options[:scope] || (config[:scope] && instance_eval(&config[:scope]))

      @search = Search.build_for(
        scope: scope,
        actions: config.fetch(:actions, {}),
        defaults: config.fetch(:defaults, {}),
        filters: options.fetch(:filters, {})
      )
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
      attr_reader :config

      def inherited(base)
        base.instance_variable_set '@config', Helper.deep_copy(config)
      end

      def scope(&block)
        config[:scope] = block
      end

      def option(name, options = nil, &block)
        options = { default: options } unless options.is_a?(Hash)

        name    = name.to_s
        default = options[:default]
        handler = options[:with] || block

        config[:defaults][name] = default unless default.nil?
        config[:actions][name]  = Helper.normalize_search_handler(handler, name)

        define_method(name) { @search.param name }
      end

      def results(*args)
        new(*args).results
      end
    end
  end
end
