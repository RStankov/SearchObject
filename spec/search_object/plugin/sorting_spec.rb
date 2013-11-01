require 'spec_helper_active_record'

module SearchObject
  module Plugin
    describe Sorting do
      def search_class
        Class.new do
          include SearchObject.module(:sorting)

          scope { Product.all }

          sort_by :name, :price
        end
      end

      describe "sorting" do
        after do
          Product.delete_all
        end

        it "sorts results based on the sort option" do
          5.times { |i| Product.create! price: i }

          search = search_class.new sort: 'price desc'
          expect(search.results.map(&:price)).to eq [4, 3, 2, 1, 0]
        end

        it "defaults to first sort by option" do
          5.times { |i| Product.create! name: "Name#{i}" }

          search = search_class.new
          expect(search.results.map(&:name)).to eq %w(Name4 Name3 Name2 Name1 Name0)
        end

        it "ignores invalid sort values" do
          search = search_class.new sort: 'invalid attribute'
          expect { search.results.to_a }.not_to raise_error
        end
      end

      describe "#sort?" do
        it "matches the sort option" do
          search = search_class.new sort: 'price desc'

          expect(search.sort?(:price)).to be_true
          expect(search.sort?(:name)).to be_false
        end

        it "matches string also" do
          search = search_class.new sort: 'price desc'

          expect(search.sort?('price')).to be_true
          expect(search.sort?('name')).to be_false
        end

        it "matches exact strings" do
          search = search_class.new sort: 'price desc'

          expect(search.sort?('price desc')).to be_true
          expect(search.sort?('price asc')).to be_false
        end
      end

      describe "#sort_attribute" do
        it "returns sort option attribute" do
          search = search_class.new sort: 'price desc'
          expect(search.sort_attribute).to eq 'price'
        end

        it "defaults to the first sort by option" do
          search = search_class.new
          expect(search.sort_attribute).to eq 'name'
        end

        it "rejects invalid sort options, uses defaults" do
          search = search_class.new sort: 'invalid'
          expect(search.sort_attribute).to eq 'name'
        end
      end

      describe "#sort_direction" do
        it "returns asc or desc" do
          expect(search_class.new(sort: 'price desc').sort_direction).to eq 'desc'
          expect(search_class.new(sort: 'price asc').sort_direction).to eq 'asc'
        end

        it "defaults to desc" do
          expect(search_class.new.sort_direction).to eq 'desc'
          expect(search_class.new(sort: 'price').sort_direction).to eq 'desc'
        end

        it "rejects invalid sort options, uses desc" do
          expect(search_class.new(sort: 'price foo').sort_direction).to eq 'desc'
        end
      end
    end
  end
end
