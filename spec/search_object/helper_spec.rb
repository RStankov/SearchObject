require 'spec_helper'

module SearchObject
  describe Helper do
    describe '.stringify_keys' do
      it 'converts hash keys to strings' do
        hash = Helper.stringify_keys a: 1, b: nil, c: false
        expect(hash).to eq 'a' => 1, 'b' => nil, 'c' => false
      end
    end

    describe '.select_keys' do
      it 'selects only given keys' do
        hash = Helper.select_keys({ a: 1, b: 2, c: 3 }, [:a, :b])
        expect(hash).to eq a: 1, b: 2
      end

      it 'ignores not existing keys' do
        hash = Helper.select_keys({}, [:a, :b])
        expect(hash).to eq({})
      end
    end

    describe 'camelize' do
      it "transforms :paging to 'Paging'" do
        expect(Helper.camelize(:paging)).to eq 'Paging'
      end
    end
  end
end
