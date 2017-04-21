require 'spec_helper'
require 'action_controller'

module SearchObject
  describe Helper do
    describe '.stringify_keys' do
      it 'converts hash keys to strings' do
        hash = described_class.stringify_keys a: 1, b: nil, c: false
        expect(hash).to eq 'a' => 1, 'b' => nil, 'c' => false
      end

      it 'converts ActionController::Parameters to hash' do
        params = ::ActionController::Parameters.new a: 1, b: nil, c: false
        hash = described_class.stringify_keys params
        expect(hash).to eq 'a' => 1, 'b' => nil, 'c' => false
      end
    end

    describe '.slice_keys' do
      it 'selects only given keys' do
        hash = described_class.slice_keys({ a: 1, b: 2, c: 3 }, [:a, :b])
        expect(hash).to eq a: 1, b: 2
      end

      it 'ignores not existing keys' do
        hash = described_class.slice_keys({}, [:a, :b])
        expect(hash).to eq({})
      end
    end

    describe 'camelize' do
      it "transforms :paging to 'Paging'" do
        expect(described_class.camelize(:paging)).to eq 'Paging'
      end
    end

    describe '.normalize_filters' do
      it 'combines defaults and filters' do
        expect(described_class.normalize_params({ 'a' => 1, 'b' => 2 }, { a: 2 }, %w(a b))).to eq 'a' => 2, 'b' => 2
      end

      it 'excludes non specified keys' do
        expect(described_class.normalize_params({ 'a' => 1 }, { b: 2 }, %w(a))).to eq 'a' => 1
      end

      it 'handles missing defaults' do
        expect(described_class.normalize_params(nil, { a: 1 }, %w(a))).to eq 'a' => 1
      end

      it 'handles missing filters' do
        expect(described_class.normalize_params(nil, nil, ['a'])).to eq({})
      end
    end

    describe 'deep_copy' do
      it 'returns a deep copy on the given object' do
        original = {
          array: [1, 2, 3],
          hash: { key: 'value' },
          boolean: true,
          number: 1,
          null: nil
        }

        deep_copy = described_class.deep_copy(original)

        original[:array][0] = 42
        original[:hash][:key] = 'other value'

        expect(deep_copy).to eq(
          array: [1, 2, 3],
          hash: { key: 'value' },
          boolean: true,
          number: 1,
          null: nil
        )
      end
    end
  end
end
