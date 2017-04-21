require 'spec_helper'
require 'ostruct'

module SearchObject
  module Plugin
    describe Enum::Handler do
      describe 'apply_filter' do
        def new_object(&block)
          klass = Class.new(&block)
          klass.new
        end

        def call(object: nil, option: nil, enums: nil, scope: nil, value:)
          described_class.apply_filter(
            object: object || new_object,
            option: option || 'option',
            enums: enums || [value],
            scope: scope || [],
            value: value
          )
        end

        it 'filters by methods based on the enum value' do
          object = new_object do
            private

            def apply_select_with_name(scope)
              scope.select { |value| value == 'name' }
            end

            def apply_select_with_age(scope)
              scope.select { |value| value == 'age' }
            end
          end

          scope = %w(name age location)

          expect(call(object: object, option: 'select', scope: scope, value: 'name')).to eq %w(name)
          expect(call(object: object, option: 'select', scope: scope, value: 'age')).to eq %w(age)
        end

        it 'raises NoMethodError when object can not handle enum method' do
          expect { call(enums: ['a'], value: 'a') }.to raise_error NoMethodError
        end

        it 'raises error when value is not an enum' do
          expect { call(enums: [], value: 'invalid') }.to raise_error Enum::InvalidEnumValueError
        end

        it 'can delegate missing enum value to object' do
          object = new_object do
            private

            def handle_invalid_option(_scope, value)
              "handles #{value} value"
            end
          end

          expect(call(object: object, enums: [], value: 'invalid')).to eq 'handles invalid value'
        end

        it 'can delegate missing enum value to object (cath all)' do
          object = new_object do
            private

            def handle_invalid_enum(option, _scope, value)
              "handles #{value} value for #{option}"
            end
          end

          expect(call(object: object, enums: [], value: 'invalid')).to eq 'handles invalid value for option'
        end
      end
    end
  end
end
