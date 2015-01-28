require 'spec_helper'
require 'active_support/core_ext/object/blank'

module SearchObject
  describe Base do
    def search_class(default_scope = [], &block)
      Class.new do
        include SearchObject.module

        scope { default_scope }

        if block.nil?
          option :value do |scope, value|
            scope.find_all { |v| v == value }
          end
        else
          class_eval &block
        end
      end
    end

    def new_search(default_scope = [], filters = {}, &block)
      search_class(default_scope, &block).new filters: filters
    end

    it "can had its #initialize method overwritten" do
      search = new_search do
        def initialize(filters = {})
          @initialized = true
          super filters
        end

        def initialized?
          @initialized
        end
      end

      expect(search).to be_initialized
    end

    it "can have multiple subclasses" do
      search1 = new_search [1, 2, 3], filter: 1 do
        option :filter do |scope, value|
          scope.select { |v| v == value }
        end
      end

      search2 = new_search [1, 2, 3], filter: 1 do
        option :filter, 2 do |scope, value|
          scope.reject { |v| v == value }
        end
      end

      expect(search1.results).not_to eq search2.results
    end

    context "scope" do
      def search_class
        Class.new do
          include SearchObject.module

          option :name do
          end
        end
      end

      it "accepts scope as argument" do
        expect(search_class.new(scope: 'scope').results).to eq 'scope'
      end

      it "raises an error if scope is not provided" do
        expect { search_class.new }.to raise_error SearchObject::MissingScopeError
      end

      it "can overwrite the search scope" do
        search_class = Class.new do
          include SearchObject.module

          scope { 'scope' }
        end

        expect(search_class.new(scope: 'other scope').results).to eq 'other scope'
      end
    end

    describe "option" do
      it "has default filter" do
        scope = [1, 2, 3]
        expect(scope).to receive(:where).with('value' => 1) { 'results' }

        search = new_search scope, value: 1 do
          option :value
        end

        expect(search.results).to eq 'results'
      end

      it "returns the scope if nil returned" do
        scope = [1, 2, 3]
        search = new_search scope, value: 'some' do
          option :value do
            nil
          end
        end

        expect(search.results).to eq scope
      end

      it "can use methods from the object" do
        search1 = new_search [1, 2, 3], filter: 1 do
          option :filter do |scope, value|
            some_instance_method(scope, value)
          end

          private

          def some_instance_method(scope, value)
            scope.select { |v| v == value }
          end
        end

        expect(search1.results).to eq [1]
      end

      it "can dispatch with instance methods" do
        search = new_search [1, 2, 3], filter: 1 do
          option :filter, with: :some_instance_method

          private

          def some_instance_method(scope, value)
            scope.select { |v| v == value }
          end
        end

        expect(search.results).to eq [1]
      end
    end

    describe "option attributes" do
      it "access option values" do
        search = new_search [], value: 1
        expect(search.value).to eq 1
      end

      it "returns default option value if option is not specified" do
        search = new_search do
          option :value, 1
        end
        expect(search.value).to eq 1
      end

      it "does not include invalid options" do
        search = new_search [], invalid: 'option'
        expect { search.invalid }.to raise_error NoMethodError
      end
    end

    describe ".results" do
      it "shortcut for creating new search and immediately returning results" do
        klass = search_class [1 ,2 ,3]
        expect(klass.results(filters: {value: 1})).to eq [1]
      end
    end

    describe "#results" do
      it "returns only the filtered search results" do
        search = new_search [1 ,2 ,3], value: 1
        expect(search.results).to eq [1]
      end

      it "can apply several options" do
        scope  = [1, 2, 3, 4, 5, 6, 7]
        search = new_search scope, bigger_than: 3, odd: true do
          option :bigger_than do |scope, value|
            scope.find_all { |v| v > value }
          end

          option :odd do |scope, value|
            scope.find_all(&:odd?) if value
          end
        end

        expect(search.results).to eq [5, 7]
      end

      it "ignores invalid filters" do
        search = new_search [1, 2, 3], invalid: 'option'
        expect(search.results).to eq [1, 2, 3]
      end

      it "can be overwritten by overwriting #fetch_results" do
        search = new_search [1, 2, 3], value: 1 do
          option :value do |scope, value|
            scope.find_all { |v| v == value }
          end

          def fetch_results
            super.map { |v| "~#{v}~" }
          end
        end

        expect(search.results).to eq ['~1~']
      end

      it "applies to default options" do
        search = new_search [1,2,3] do
          option :value, 1 do |scope, value|
            scope.select { |v| v == value }
          end
        end
        expect(search.results).to eq [1]
      end
    end

    describe "#results?" do
      it "returns true if there are results" do
        expect(new_search([1,2,3], value: 1).results?).to be_true
      end

      it "returns false if there aren't any results" do
        expect(new_search([1,2,3], value: 4).results?).to be_false
      end
    end

    describe "#count" do
      it "counts the number of results" do
        expect(new_search([1,2,3], value: 1).count).to eq 1
      end

      it "can't be bypassed by plug ins" do
        search = new_search [1,2,3] do
          def fetch_results
            []
          end
        end

        expect(search.count).to eq 3
      end
    end

    describe "#params" do
      it "exports options as params" do
        search = new_search [], value: 1
        expect(search.params).to eq 'value' => 1
      end

      it "can overwrite options (mainly used for url handers)" do
        search = new_search [], value: 1
        expect(search.params(value: 2)).to eq 'value' => 2
      end

      it "ignores missing options" do
        search = new_search
        expect(search.params).to eq({})
      end

      it "ignores invalid options" do
        search = new_search [], invalid: 'option'
        expect(search.params).to eq({})
      end

      it "includes default options" do
        search = new_search do
          option :value, 1
        end
        expect(search.params).to eq 'value' => 1
      end
    end
  end
end
