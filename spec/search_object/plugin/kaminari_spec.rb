require 'spec_helper_active_record'

require_relative '../../support/kaminari_setup'

module SearchObject
  module Plugin
    describe Paging do
      def search_class
        Class.new do
          include SearchObject.module(:kaminari)

          scope { Product }

          per_page 2
        end
      end

      after do
        Product.delete_all
      end

      it "paginates" do
        10.times { |i| Product.create name: "product_#{i}" }
        search = search_class.new({}, 3)
        expect(search.results.map(&:name)).to eq %w(product_4 product_5)
      end

      it "uses will paginate" do
        search = search_class.new
        expect(search.results.respond_to? :total_pages).to be_true
      end

      it "treats nil page as 0" do
        search = search_class.new({}, nil)
        expect(search.page).to eq 0
      end

      it "treats negative page numbers as positive" do
        search = search_class.new({}, -1)
        expect(search.page).to eq 1
      end

      it "gives the real count" do
        10.times { |i| Product.create name: "product_#{i}" }
        search = search_class.new({}, 1)
        expect(search.count).to eq 10
      end
    end
  end
end
