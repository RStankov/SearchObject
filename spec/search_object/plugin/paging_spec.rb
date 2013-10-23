require_relative '../../spec_helper_active_record'

module SearchObject
  module Plugin
    describe Paging do
      def search_class
        Class.new do
          include SearchObject.module
          include Paging

          scope { Product }

          def per_page
            2
          end
        end
      end

      it "paginates results (by offset and limit)" do
        10.times { |i| Product.create name: "product_#{i}" }
        search = search_class.new({}, 1)
        expect(search.results.map(&:name)).to eq %w(product_2 product_3)
      end

      it "treats nil page as 0" do
        search = search_class.new({}, nil)
        expect(search.page).to eq 0
      end

      it "treats negative page numbers as positive" do
        search = search_class.new({}, -1)
        expect(search.page).to eq 1
      end
    end
  end
end
