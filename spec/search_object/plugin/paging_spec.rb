# frozen_string_literal: true

require 'spec_helper_active_record'

module SearchObject
  module Plugin
    describe Paging do
      it_behaves_like 'a paging plugin'
    end
  end
end
