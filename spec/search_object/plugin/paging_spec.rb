require 'spec_helper_active_record'

module SearchObject
  module Plugin
    describe Paging do
      def search_class
        Class.new do
          include SearchObject.module(:paging)

          scope { Product }

          def per_page
            2
          end
        end
      end

      after do
        Product.delete_all
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

      it "requires overwrite of per_page" do
        klass = Class.new do
          include SearchObject.module(:paging)
          scope { Product }
        end
        expect { klass.new.results }.to raise_error NoMethodError
      end

      it "gives the real count" do
        10.times { |i| Product.create name: "product_#{i}" }
        search = search_class.new({}, 1)
        expect(search.count).to eq 10
      end
    end
  end
end
