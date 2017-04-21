module SearchObject
  module Plugin
    module Enum
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def option(name, options = nil, &block)
          return super unless options.is_a?(Hash) && options[:enum]

          raise BlockIgnoredError if block
          raise WithIgnoredError if options[:with]

          handler = Handler.build(name, options[:enum])

          super(name, options, &handler)
        end
      end

      module Handler
        module_function

        def build(name, enums)
          enums = enums.map(&:to_s)
          handler = self
          ->(scope, value) { handler.apply_filter(object: self, option: name, enums: enums, scope: scope, value: value) }
        end

        def apply_filter(object:, option:, enums:, scope:, value:)
          unless enums.include? value
            return handle_invalid_value(
              object: object,
              option: option,
              enums: enums,
              scope: scope,
              value: value
            )
          end

          object.send("apply_#{option}_with_#{value}", scope)
        end

        def handle_invalid_value(object:, option:, enums:, scope:, value:)
          specific = "handle_invalid_#{option}"
          return object.send(specific, scope, value) if object.respond_to? specific, true

          catch_all = 'handle_invalid_enum'
          return object.send(catch_all, option, scope, value) if object.respond_to? catch_all, true

          raise InvalidEnumValueError.new(option, enums, value)
        end
      end

      class InvalidEnumValueError < ArgumentError
        def initialize(option, enums, value)
          super "Wrong value '#{value}' used for enum #{option} (expected one of #{enums.join(', ')})"
        end
      end

      class BlockIgnoredError < ArgumentError
        def initialize(message = "Enum options don't accept blocks")
          super message
        end
      end

      class WithIgnoredError < ArgumentError
        def initialize(message = "Enum options don't accept :with")
          super message
        end
      end
    end
  end
end
