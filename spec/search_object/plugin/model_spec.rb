require 'spec_helper'

require 'active_model_lint-rspec'

module SearchObject
  module Plugin
    class ExtendedModel
      include SearchObject.module(:model)

      # Fake errors
      # Since SearchObject is focused to plain search forms,
      # which don't have validation most of the time
      def errors
        Hash.new([])
      end
    end

    describe ExtendedModel do
      it_behaves_like 'an ActiveModel'
    end
  end
end
