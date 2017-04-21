module SearchObject
  module Plugin
    module Enum
      def self.included(base)
        base.extend ClassMethods
      end

      module Handler
        module_function

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
    end
  end
end
