# frozen_string_literal: true

require 'spec_helper_active_record'

require 'will_paginate'
require 'will_paginate/active_record'

module SearchObject
  module Plugin
    describe WillPaginate do
      it_behaves_like 'a paging plugin' do
        it 'uses will_paginate gem' do
          search = search_with_page
          expect(search.results).to be_respond_to :total_entries
        end
      end
    end
  end
end
