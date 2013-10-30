module SearchObject
  module Plugin
    module Paging
      def initialize(*args)
        @page = args.pop.to_i.abs
        super args
      end

      def page
        @page
      end

      def per_page
       raise NoMethodError
      end

      private

      def fetch_results
        apply_paging super
      end

      def apply_paging(scope)
        scope.limit(page * per_page).offset(per_page)
      end
    end
  end
end
