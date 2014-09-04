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

    def initialize(*args)
      @search = self.class.search args
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
      def search(args)
        scope  = (@scope && @scope.call) || args.shift
        params = @defaults.merge(Helper.select_keys Helper.stringify_keys(args.shift || {}), @actions.keys)

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
