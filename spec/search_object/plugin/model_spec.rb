# frozen_string_literal: true

require 'spec_helper'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/delegation'
require 'active_support/concern'
require 'active_model/conversion'
require 'active_model/naming'
require 'active_model/lint'

module SearchObject
  module Plugin
    class ExtendedModel
      include SearchObject.module(:model)

      scope { [] }

      # Fake errors
      # Since SearchObject is focused on plain search forms,
      # validations are not needed most of the time
      def errors
        Hash.new([])
      end
    end

    describe ExtendedModel do
      include ActiveModel::Lint::Tests

      let(:model) { subject }

      def assert(condition, message = nil)
        expect(condition).to be_truthy, message
      end

      def assert_kind_of(expected_kind, object, message = nil)
        expect(object).to be_kind_of(expected_kind), message
      end

      def assert_equal(expected_value, value, message = nil)
        expect(value).to eq(expected_value), message
      end

      def assert_respond_to(object, method, message = nil)
        expect(object).to respond_to(method), message
      end

      ActiveModel::Lint::Tests.public_instance_methods.map(&:to_s).grep(/^test/).each do |method|
        example(method.tr('_', ' ')) { send method }
      end
    end
  end
end
