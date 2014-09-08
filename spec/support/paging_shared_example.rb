shared_examples_for "a paging plugin" do
  after do
    Product.delete_all
  end

  def search_class
    plugin_name = described_class.name.demodulize.underscore.to_sym
    Class.new do
      include SearchObject.module(plugin_name)

      scope { Product }

      per_page 2

      max_per_page 10
    end
  end

  def search_with_page(page = nil, per_page = nil)
    search_class.new page: page, per_page: per_page
  end

  describe "#results" do
    it "paginates results" do
      4.times { |i| Product.create name: "product_#{i}" }
      search = search_with_page 3, 1

      expect(search.results.map(&:name)).to eq %w(product_2)
    end
  end

  describe "#page" do
    it "treats nil page as 0" do
      search = search_with_page nil
      expect(search.page).to eq 0
    end

    it "treats negative page numbers as positive" do
      search = search_with_page -1
      expect(search.page).to eq 1
    end
  end

  describe "#per_page" do
    it "returns the class defined per page" do
      search = search_class.new
      expect(search.per_page).to eq 2
    end

    it "can be overwritten as option" do
      search = search_class.new per_page: 3
      expect(search.per_page).to eq 3
    end

    it "respects max per page" do
      search = search_class.new per_page: 100
      expect(search.per_page).to eq 10
    end
  end

  describe "#count" do
    it "gives the real count" do
      10.times { |i| Product.create name: "product_#{i}" }
      search = search_with_page 1
      expect(search.count).to eq 10
    end
  end
end
