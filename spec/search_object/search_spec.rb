require 'spec_helper'

module SearchObject
  describe Search do
    describe '.params' do
      it 'returns the passed params' do
        search = Search.new('scope', 'params', {})
        expect(search.params).to eq 'params'
      end
    end

    describe '.param' do
      it 'returns the param value' do
        search = Search.new('scope', { name: 'value' }, {})
        expect(search.param(:name)).to eq 'value'
      end
    end

    describe '.query' do
      it 'returns filtered result' do
        actions = {
          min: ->(scope, min) { scope.select { |v| v > min } }
        }

        search = Search.new [1, 2, 3], { min: 2 }, actions
        expect(search.query(Object.new)).to eq [3]
      end

      it 'applies actions to params' do
        actions = {
          min: ->(scope, min) { scope.select { |v| v > min } },
          max: ->(scope, max) { scope.select { |v| v < max } }
        }

        search = Search.new [1, 2, 3, 4, 5], { min: 2, max: 5 }, actions
        expect(search.query(Object.new)).to eq [3, 4]
      end

      it 'handles nil returned from action' do
        actions = {
          odd: ->(scope, odd) { scope.select(&:odd?) if odd }
        }

        search = Search.new [1, 2, 3, 4, 5], { odd: false }, actions
        expect(search.query(Object.new)).to eq [1, 2, 3, 4, 5]
      end

      it 'executes action in the passed context' do
        actions = {
          search: ->(scope, _) { scope.select { |v| v == target_value } }
        }

        context = OpenStruct.new target_value: 2

        search = Search.new [1, 2, 3, 4, 5], { search: true }, actions
        expect(search.query(context)).to eq [2]
      end
    end

    describe '.count' do
      it 'counts the results of the query' do
        actions = {
          value: ->(scope, value) { scope.select { |v| v == value } }
        }

        search = Search.new [1, 2, 3], { value: 2 }, actions
        expect(search.count(Object.new)).to eq 1
      end
    end
  end
end
