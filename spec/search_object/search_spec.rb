# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'

module SearchObject
  describe Search do
    describe '.params' do
      it 'stringify param keys' do
        search = described_class.new(scope: 'scope', params: { name: 'value' }, options: { 'name' => nil })
        expect(search.params).to eq 'name' => 'value'
      end

      it 'filters invalid params' do
        search = described_class.new(scope: 'scope', params: { name: 'value' })
        expect(search.params).to eq({})
      end

      it 'supports default values' do
        search = described_class.new(scope: 'scope', params: {}, defaults: { 'name' => 'value' })
        expect(search.params).to eq 'name' => 'value'
      end

      it 'can be updated' do
        search = described_class.new(scope: 'scope', params: { name: 'value' }, options: { 'name' => nil })
        search.params = { name: 'updated', fake: 'value' }

        expect(search.params).to eq 'name' => 'updated'
      end
    end

    describe '.param' do
      it 'returns the param value' do
        search = described_class.new(scope: 'scope', params: { name: 'value' }, options: { 'name' => nil })
        expect(search.param(:name)).to eq 'value'
      end
    end

    describe '.query' do
      it 'returns filtered result' do
        options = {
          'min' => ->(scope, min) { scope.select { |v| v > min } }
        }

        search = described_class.new(scope: [1, 2, 3], params: { min: 2 }, options: options)
        expect(search.query(Object.new)).to eq [3]
      end

      it 'applies options to params' do
        options = {
          'min' => ->(scope, min) { scope.select { |v| v > min } },
          'max' => ->(scope, max) { scope.select { |v| v < max } }
        }

        search = described_class.new(scope: [1, 2, 3, 4, 5], params: { min: 2, max: 5 }, options: options)
        expect(search.query(Object.new)).to eq [3, 4]
      end

      it 'handles nil returned from action' do
        options = {
          'odd' => ->(scope, odd) { scope.select(&:odd?) if odd }
        }

        search = described_class.new(scope: [1, 2, 3, 4, 5], params: { odd: false }, options: options)
        expect(search.query(Object.new)).to eq [1, 2, 3, 4, 5]
      end

      it 'executes action in the passed context' do
        options = {
          'search' => ->(scope, _) { scope.select { |v| v == target_value } }
        }

        context = OpenStruct.new target_value: 2

        search = described_class.new(scope: [1, 2, 3, 4, 5], params: { search: true }, options: options)
        expect(search.query(context)).to eq [2]
      end
    end

    describe '.count' do
      it 'counts the results of the query' do
        options = {
          'value' => ->(scope, value) { scope.select { |v| v == value } }
        }

        search = described_class.new(scope: [1, 2, 3], params: { value: 2 }, options: options)
        expect(search.count(Object.new)).to eq 1
      end
    end
  end
end
