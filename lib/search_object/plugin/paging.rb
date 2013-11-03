module SearchObject
  module Plugin
    module Paging
      def self.included(base)
        base.extend ClassMethods
      end

      def initialize(*args)
        @page = args.pop.to_i.abs
        super *args
      end

      def page
        @page
      end

      def per_page
        self.class.get_per_page
      end

      private

      def fetch_results
        apply_paging super
      end

      def apply_paging(scope)
        scope.limit(page * per_page).offset(per_page)
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
