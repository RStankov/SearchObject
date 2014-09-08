require 'spec_helper_active_record'

require 'will_paginate'
require 'will_paginate/active_record'

module SearchObject
  module Plugin
    describe Paging do
      def search_class
        Class.new do
          include SearchObject.module(:will_paginate)

          scope { Product }

          per_page 2
        end
      end

      after do
        Product.delete_all
      end

      def search_with_page(page = nil)
        search_class.new({}, page)
      end

      it "paginates" do
        10.times { |i| Product.create name: "product_#{i}" }
        search = search_with_page 2
        expect(search.results.map(&:name)).to eq %w(product_2 product_3)
      end

      it "uses will paginate" do
        search = search_with_page
        expect(search.results.respond_to? :total_entries).to be_true
      end

      it "treats nil page as 0" do
        search = search_with_page nil
        expect(search.page).to eq 0
      end

      it "treats negative page numbers as positive" do
        search = search_with_page -1
        expect(search.page).to eq 1
      end

      it "gives the real count" do
        10.times { |i| Product.create name: "product_#{i}" }
        search = search_with_page 1
        expect(search.count).to eq 10
      end
    end
  end
end
