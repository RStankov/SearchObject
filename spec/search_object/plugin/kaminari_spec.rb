require 'spec_helper_active_record'

require_relative '../../support/kaminari_setup'

module SearchObject
  module Plugin
    describe Kaminari do
      it_behaves_like "a paging plugin" do
        it "uses kaminari gem" do
          search = search_with_page
          expect(search.results.respond_to? :total_pages).to be_truthy
        end
      end
    end
  end
end
