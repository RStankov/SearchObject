require 'spec_helper_active_record'

module SearchObject
  module Plugin
    describe Paging do
      def search_class
        Class.new do
          include SearchObject.module(:paging)

          scope { Product }

          per_page 2
        end
      end

      after do
        Product.delete_all
      end

      def search_with_page(page = nil)
        search_class.new page: page
      end

      it "paginates results (by offset and limit)" do
        10.times { |i| Product.create name: "product_#{i}" }
        search = search_with_page 1
        expect(search.results.map(&:name)).to eq %w(product_2 product_3)
      end

      describe "#page" do
        it "treats nil page as 0" do
          search = search_with_page nil
          expect(search.page).to eq 0
        end

        it "treats negative page numbers as positive" do
          search = search_with_page -1
          expect(search.page).to eq 1
        end
      end

      describe '#per_page' do
        it "returns the class defined per page" do
          search = search_class.new
          expect(search.per_page).to eq 2
        end

        it "can be overwritten as option" do
          search = search_class.new per_page: 3
          expect(search.per_page).to eq 3
        end
      end

      describe "#count" do
        it "gives the real count" do
          10.times { |i| Product.create name: "product_#{i}" }
          search = search_with_page 1
          expect(search.count).to eq 10
        end
      end
    end
  end
end
