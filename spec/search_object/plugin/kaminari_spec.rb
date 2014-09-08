require 'spec_helper_active_record'

require_relative '../../support/kaminari_setup'

module SearchObject
  module Plugin
    describe Kaminari do
      it_behaves_like "a paging plugin" do
        it "uses kaminari gem" do
          search = search_with_page
          expect(search.results.respond_to? :total_pages).to be_true
        end

        describe "#results" do
          it "paginates results" do
            4.times { |i| Product.create name: "product_#{i}" }
            search = search_with_page 3, 1

            expect(search.results.map(&:name)).to eq %w(product_2)
          end
        end
      end
    end
  end
end
