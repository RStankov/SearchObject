require 'spec_helper_active_record'

require 'will_paginate'
require 'will_paginate/active_record'

module SearchObject
  module Plugin
    describe WillPaginate do
      it_behaves_like "a paging plugin" do
        it "uses will_paginate gem" do
          search = search_with_page
          expect(search.results.respond_to? :total_entries).to be_truthy
        end
      end
    end
  end
end
