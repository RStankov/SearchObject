require 'spec_helper_active_record'

module SearchObject
  module Plugin
    describe Sorting do
      def search_class
        Class.new do
          include SearchObject.module(:sorting)

          scope { Product.all }

          sort_by :name, :price

          option :name
          option :price
        end
      end

      def search_with_sort(sort = nil, filters = {})
        search_class.new({sort: sort}.merge(filters))
      end

      describe "sorting" do
        after do
          Product.delete_all
        end

        it "sorts results based on the sort option" do
          5.times { |i| Product.create! price: i }

          search = search_with_sort 'price desc'
          expect(search.results.map(&:price)).to eq [4, 3, 2, 1, 0]
        end

        it "defaults to first sort by option" do
          5.times { |i| Product.create! name: "Name#{i}" }

          search = search_with_sort
          expect(search.results.map(&:name)).to eq %w(Name4 Name3 Name2 Name1 Name0)
        end

        it "ignores invalid sort values" do
          search = search_with_sort 'invalid attribute'
          expect { search.results.to_a }.not_to raise_error
        end
      end

      describe "#sort?" do
        it "matches the sort option" do
          search = search_with_sort 'price desc'

          expect(search.sort?(:price)).to be_true
          expect(search.sort?(:name)).to be_false
        end

        it "matches string also" do
          search = search_with_sort 'price desc'

          expect(search.sort?('price')).to be_true
          expect(search.sort?('name')).to be_false
        end

        it "matches exact strings" do
          search = search_with_sort 'price desc'

          expect(search.sort?('price desc')).to be_true
          expect(search.sort?('price asc')).to be_false
        end
      end

      describe "#sort_attribute" do
        it "returns sort option attribute" do
          search = search_with_sort 'price desc'
          expect(search.sort_attribute).to eq 'price'
        end

        it "defaults to the first sort by option" do
          search = search_with_sort
          expect(search.sort_attribute).to eq 'name'
        end

        it "rejects invalid sort options, uses defaults" do
          search = search_with_sort 'invalid'
          expect(search.sort_attribute).to eq 'name'
        end
      end

      describe "#sort_direction" do
        it "returns asc or desc" do
          expect(search_with_sort('price desc').sort_direction).to eq 'desc'
          expect(search_with_sort('price asc').sort_direction).to eq 'asc'
        end

        it "defaults to desc" do
          expect(search_with_sort.sort_direction).to eq 'desc'
          expect(search_with_sort('price').sort_direction).to eq 'desc'
        end

        it "rejects invalid sort options, uses desc" do
          expect(search_with_sort('price foo').sort_direction).to eq 'desc'
        end
      end

      describe "#sort_direction_for" do
        it "returns desc if current sort attribute is not the given attribute" do
          expect(search_with_sort('price desc').sort_direction_for('name')).to eq 'desc'
        end

        it "returns asc if current sort attribute is the given attribute" do
          expect(search_with_sort('name desc').sort_direction_for('name')).to eq 'asc'
        end

        it "returns desc if current sort attribute is the given attribute, but asc with direction" do
          expect(search_with_sort('name asc').sort_direction_for('name')).to eq 'desc'
        end
      end

      describe "#sort_params_for" do
        it "adds sort direction" do
          search = search_with_sort 'name', name: 'test'
          expect(search.sort_params_for(:price)).to eq 'sort' => 'price desc', 'name' => 'test'
        end

        it "reverses sort direction if this is the current sort attribute" do
          search = search_with_sort 'name desc', name: 'test'
          expect(search.sort_params_for(:name)).to eq 'sort' => 'name asc', 'name' => 'test'
        end

        it "accepts additional options" do
          search = search_with_sort
          expect(search.sort_params_for(:price, name: 'value')).to eq 'sort' => 'price desc', 'name' => 'value'
        end
      end

      describe "#reverted_sort_direction" do
        it "reverts sorting direction" do
          expect(search_with_sort('price desc').reverted_sort_direction).to eq 'asc'
          expect(search_with_sort('price asc').reverted_sort_direction).to eq 'desc'
        end
      end
    end
  end
end
