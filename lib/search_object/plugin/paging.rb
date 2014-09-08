module SearchObject
  module Plugin
    module Paging
      def self.included(base)
        base.extend ClassMethods
      end

      attr_reader :page, :per_page

      def initialize(options = {})
        @page     = options[:page].to_i.abs
        @per_page = options.fetch(:per_page) { self.class.get_per_page }.to_i.abs

        super options
      end

      private

      def fetch_results
        apply_paging super
      end

      def apply_paging(scope)
        scope.limit(per_page).offset(page * per_page)
      end

      module ClassMethods
        def per_page(number)
          @per_page = number.to_i.abs
        end

        def get_per_page
          @per_page ||= 25
        end
      end
    end
  end
end
