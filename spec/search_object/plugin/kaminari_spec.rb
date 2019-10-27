# frozen_string_literal: true

require 'spec_helper_active_record'
require 'kaminari'

module SearchObject
  module Plugin
    describe Kaminari do
      it_behaves_like 'a paging plugin' do
        it 'uses kaminari gem' do
          search = search_with_page
          expect(search.results).to be_respond_to :total_pages
        end
      end
    end
  end
end
