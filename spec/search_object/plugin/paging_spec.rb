require 'spec_helper_active_record'

module SearchObject
  module Plugin
    describe Paging do
      it_behaves_like "a paging plugin" do
        describe "#results" do
          it "paginates results" do
            4.times { |i| Product.create name: "product_#{i}" }
            search = search_with_page 3, 1

            expect(search.results.map(&:name)).to eq %w(product_3)
          end
        end
      end
    end
  end
end
