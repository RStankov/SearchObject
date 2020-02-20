# frozen_string_literal: true

module SearchObject
  module Plugin
    module Enum
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def option(name, options = nil, &block)
          return super unless options.is_a?(Hash) && options[:enum]

          handler = options[:with] || block || Handler.build(name, options[:enum])

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
          return if value.nil? || value == ''

          return handle_invalid_value(object: object, option: option, enums: enums, scope: scope, value: value) unless enums.include? value.to_s

          object.send("apply_#{Helper.underscore(option)}_with_#{Helper.underscore(value)}", scope)
        end

        def handle_invalid_value(object:, option:, enums:, scope:, value:)
          specific = "handle_invalid_#{option}"
          return object.send(specific, scope, value) if object.respond_to? specific, true

          return object.handle_invalid_enum(option, scope, value) if object.respond_to? :handle_invalid_enum, true

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
