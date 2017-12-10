require 'spec_helper'
require 'ostruct'

module SearchObject
  module Plugin
    describe Enum do
      class TestSearch
        include SearchObject.module(:enum)

        scope { [1, 2, 3, 4, 5] }

        option :filter, enum: %w[odd even]

        private

        def apply_filter_with_odd(scope)
          scope.select(&:odd?)
        end

        def apply_filter_with_even(scope)
          scope.select(&:even?)
        end

        def handle_invalid_filter(_scope, value)
          "invalid filter - #{value}"
        end
      end

      it 'can filter by enum values' do
        expect(TestSearch.results(filters: { filter: 'odd' })).to eq [1, 3, 5]
        expect(TestSearch.results(filters: { filter: 'even' })).to eq [2, 4]
      end

      it 'ignores blank values' do
        expect(TestSearch.results(filters: { filter: nil })).to eq [1, 2, 3, 4, 5]
        expect(TestSearch.results(filters: { filter: '' })).to eq [1, 2, 3, 4, 5]
      end

      it 'handles wrong enum values' do
        expect(TestSearch.results(filters: { filter: 'foo' })).to eq 'invalid filter - foo'
      end

      it 'raises when block is passed with enum option' do
        expect do
          Class.new do
            include SearchObject.module(:enum)

            option(:filter, enum: %w[a b]) { |_scope, _value| nil }
          end
        end.to raise_error Enum::BlockIgnoredError
      end

      it 'raises when :with is passed with enum option' do
        expect do
          Class.new do
            include SearchObject.module(:enum)

            option :filter, enum: %w[a b], with: :method_name
          end
        end.to raise_error Enum::WithIgnoredError
      end
    end

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

          scope = %w[name age location]

          expect(call(object: object, option: 'select', scope: scope, value: 'name')).to eq %w[name]
          expect(call(object: object, option: 'select', scope: scope, value: 'age')).to eq %w[age]
        end

        it 'raises NoMethodError when object can not handle enum method' do
          expect { call(enums: ['a'], value: 'a') }.to raise_error NoMethodError
        end

        it 'raises error when value is not an enum' do
          expect { call(enums: [], value: 'invalid') }.to raise_error Enum::InvalidEnumValueError
        end

        it 'can delegate missing enum value to object' do
          object = new_object do
            def handle_invalid_option(_scope, value)
              "handles #{value} value"
            end
          end

          expect(call(object: object, enums: [], value: 'invalid')).to eq 'handles invalid value'
        end

        it 'can delegate missing enum value to object (cath all)' do
          object = new_object do
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
