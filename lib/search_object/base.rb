# frozen_string_literal: true

module SearchObject
  module Base
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        @config = {
          defaults: {},
          options: {}
        }
      end
    end

    def initialize(options = {})
      config = self.class.config
      scope  = options[:scope] || (config[:scope] && instance_eval(&config[:scope]))

      raise MissingScopeError unless scope

      @search = Search.new(
        scope: scope,
        options: config[:options],
        defaults: config[:defaults],
        params: options[:filters]
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

    def params=(params)
      @count = nil
      @results = nil
      @search.params = params
    end

    def params(additions = {})
      if additions.empty?
        @search.params
      else
        @search.params.merge Helper.stringify_keys(additions)
      end
    end

    def param?(*args)
      if args.size == 1
        params.key?(args[0].to_s)
      elsif args.size == 2
        params[args[0].to_s] == args[1]
      else
        raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1 or 2)"
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
        config[:options][name]  = Helper.normalize_search_handler(handler, name)

        define_method(name) { @search.param name }
      end

      def results(*args)
        new(*args).results
      end
    end
  end
end
