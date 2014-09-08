require 'spec_helper'

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

      before do
        @model = subject
      end

      def assert(condition, message = nil)
        expect(condition).to be_true, message
      end

      def assert_kind_of(expected_kind, object, message = nil)
        expect(object).to be_kind_of(expected_kind), message
      end

      ActiveModel::Lint::Tests.public_instance_methods.map { |method| method.to_s }.grep(/^test/).each do |method|
        example(method.gsub('_', ' ')) { send method }
      end
    end
  end
end
