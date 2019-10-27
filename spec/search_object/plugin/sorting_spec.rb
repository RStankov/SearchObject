# frozen_string_literal: true

require 'spec_helper_active_record'

module SearchObject
  module Plugin
    describe Sorting do
      def search_class
        Class.new do
          include SearchObject.module(:sorting)

          scope { Product.all }

          sort_by :name, :price, :created_at

          option :name
          option :price
          option(:category) { |scope, _| scope.joins(:category) }
        end
      end

      def search_with_sort(sort = nil, filters = {})
        search_class.new filters: { sort: sort }.merge(filters)
      end

      it 'can be inherited' do
        child_class = Class.new(search_class)
        expect(child_class.new.sort_attribute).to eq 'name'
      end

      describe 'sorting' do
        after do
          Product.delete_all
        end

        it 'sorts results based on the sort option' do
          5.times { |i| Product.create! price: i }

          search = search_with_sort 'price desc'
          expect(search.results.map(&:price)).to eq [4, 3, 2, 1, 0]
        end

        it 'defaults to first sort by option' do
          search_class = Class.new do
            include SearchObject.module(:sorting)

            scope { Product.all }

            sort_by :name, :price, :created_at, default: :price
          end

          5.times { |i| Product.create! price: i }

          expect(search_class.new.results.map(&:price)).to eq [4, 3, 2, 1, 0]
        end

        it 'accepts default sorting' do
          5.times { |i| Product.create! name: "Name#{i}" }

          search = search_with_sort
          expect(search.results.map(&:name)).to eq %w[Name4 Name3 Name2 Name1 Name0]
        end

        it 'ignores invalid sort values' do
          search = search_with_sort 'invalid attribute'
          expect { search.results.to_a }.not_to raise_error
        end

        it 'can handle renames of sorting in joins' do
          older_category = Category.create! name: 'older'
          newer_category = Category.create! name: 'newer'

          product_of_newer_category = Product.create! name: 'older product', category: newer_category
          product_of_older_category = Product.create! name: 'newer product', category: older_category

          search = search_with_sort 'created_at desc', category: ''

          expect(search.results.map(&:name)).to eq [product_of_older_category.name, product_of_newer_category.name]
        end
      end

      describe '#sort?' do
        it 'matches the sort option' do
          search = search_with_sort 'price desc'

          expect(search).to be_sort :price
          expect(search).not_to be_sort :name
        end

        it 'matches string also' do
          search = search_with_sort 'price desc'

          expect(search).to be_sort 'price'
          expect(search).not_to be_sort 'name'
        end

        it 'matches exact strings' do
          search = search_with_sort 'price desc'

          expect(search).to be_sort 'price desc'
          expect(search).not_to be_sort 'price asc'
        end
      end

      describe '#sort_attribute' do
        it 'returns sort option attribute' do
          search = search_with_sort 'price desc'
          expect(search.sort_attribute).to eq 'price'
        end

        it 'defaults to the first sort by option' do
          search = search_with_sort
          expect(search.sort_attribute).to eq 'name'
        end

        it 'rejects invalid sort options, uses defaults' do
          search = search_with_sort 'invalid'
          expect(search.sort_attribute).to eq 'name'
        end
      end

      describe '#sort_direction' do
        it 'returns asc or desc' do
          expect(search_with_sort('price desc').sort_direction).to eq 'desc'
          expect(search_with_sort('price asc').sort_direction).to eq 'asc'
        end

        it 'defaults to desc' do
          expect(search_with_sort.sort_direction).to eq 'desc'
          expect(search_with_sort('price').sort_direction).to eq 'desc'
        end

        it 'rejects invalid sort options, uses desc' do
          expect(search_with_sort('price foo').sort_direction).to eq 'desc'
        end
      end

      describe '#sort_direction_for' do
        it 'returns desc if current sort attribute is not the given attribute' do
          expect(search_with_sort('price desc').sort_direction_for('name')).to eq 'desc'
        end

        it 'returns asc if current sort attribute is the given attribute' do
          expect(search_with_sort('name desc').sort_direction_for('name')).to eq 'asc'
        end

        it 'returns desc if current sort attribute is the given attribute, but asc with direction' do
          expect(search_with_sort('name asc').sort_direction_for('name')).to eq 'desc'
        end
      end

      describe '#sort_params_for' do
        it 'adds sort direction' do
          search = search_with_sort 'name', name: 'test'
          expect(search.sort_params_for(:price)).to eq 'sort' => 'price desc', 'name' => 'test'
        end

        it 'reverses sort direction if this is the current sort attribute' do
          search = search_with_sort 'name desc', name: 'test'
          expect(search.sort_params_for(:name)).to eq 'sort' => 'name asc', 'name' => 'test'
        end

        it 'accepts additional options' do
          search = search_with_sort
          expect(search.sort_params_for(:price, name: 'value')).to eq 'sort' => 'price desc', 'name' => 'value'
        end
      end

      describe '#reverted_sort_direction' do
        it 'reverts sorting direction' do
          expect(search_with_sort('price desc').reverted_sort_direction).to eq 'asc'
          expect(search_with_sort('price asc').reverted_sort_direction).to eq 'desc'
        end
      end
    end
  end
end
