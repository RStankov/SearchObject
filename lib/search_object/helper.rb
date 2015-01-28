module SearchObject
  module Helper
    class << self
      def stringify_keys(hash)
        Hash[(hash || {}).map { |k, v| [k.to_s, v]}]
      end

      def select_keys(hash, keys)
        keys.inject({}) do |memo, key|
          memo[key] = hash[key] if hash.has_key? key
          memo
        end
      end

      def camelize(text)
        text.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      end

      def ensure_included(item, collection)
        if collection.include? item
          item
        else
          collection.first
        end
      end

      def define_module(&block)
        Module.new do
          define_singleton_method :included do |base|
            base.class_eval &block
          end
        end
      end

      def normalize_search_handler(handler, name)
        case handler
          when Symbol then ->(scope, value) { method(handler).call scope, value }
          when Proc then handler
          else ->(scope, value) { scope.where name => value unless value.blank? }
        end
      end
    end
  end
end
