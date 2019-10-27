# frozen_string_literal: true

shared_examples_for 'a paging plugin' do
  after do
    Product.delete_all
  end

  def define_search_class(&block)
    plugin_name = described_class.name.demodulize.underscore.to_sym
    Class.new do
      include SearchObject.module(plugin_name)

      instance_eval(&block) if block_given?
    end
  end

  def search_class
    define_search_class do
      scope { Product }

      per_page 2

      min_per_page 2
      max_per_page 10
    end
  end

  def search_with_page(page = nil, per_page = nil)
    search_class.new page: page, per_page: per_page
  end

  it 'can be inherited' do
    child_class = Class.new(search_class)
    expect(child_class.new.per_page).to eq 2
  end

  describe '#results' do
    it 'paginates results' do
      6.times { |i| Product.create name: "product_#{i}" }
      search = search_with_page 2, 2

      expect(search.results.map(&:name)).to eq %w[product_2 product_3]
    end
  end

  describe '#page' do
    it 'treats nil page as 0' do
      search = search_with_page nil
      expect(search.page).to eq 0
    end

    it 'treats negative page numbers as positive' do
      search = search_with_page(-1)
      expect(search.page).to eq 0
    end
  end

  describe '#per_page' do
    it 'returns the class defined per page' do
      search = search_class.new
      expect(search.per_page).to eq 2
    end

    it 'can be overwritten as option' do
      search = search_class.new per_page: 3
      expect(search.per_page).to eq 3
    end

    it 'respects min per page' do
      search = search_class.new per_page: 1
      expect(search.per_page).to eq 2
    end

    it 'respects max per page' do
      search = search_class.new per_page: 100
      expect(search.per_page).to eq 10
    end
  end

  describe '#count' do
    it 'gives the real count' do
      10.times { |i| Product.create name: "product_#{i}" }
      search = search_with_page 1
      expect(search.count).to eq 10
    end
  end

  describe '.per_page' do
    it 'does not accept 0' do
      expect { define_search_class { per_page(0) } }.to raise_error SearchObject::InvalidNumberError
    end

    it 'does not accept negative number' do
      expect { define_search_class { per_page(-1) } }.to raise_error SearchObject::InvalidNumberError
    end
  end

  describe '.min_per_page' do
    it 'does not accept 0' do
      expect { define_search_class { min_per_page(0) } }.to raise_error SearchObject::InvalidNumberError
    end

    it 'does not accept negative number' do
      expect { define_search_class { min_per_page(-1) } }.to raise_error SearchObject::InvalidNumberError
    end
  end

  describe '.max_per_page' do
    it 'does not accept 0' do
      expect { define_search_class { max_per_page(0) } }.to raise_error SearchObject::InvalidNumberError
    end

    it 'does not accept negative number' do
      expect { define_search_class { max_per_page(-1) } }.to raise_error SearchObject::InvalidNumberError
    end
  end
end
