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

      def fetch_results
        super.limit(@page * per_page).offset(per_page)
      end
    end
  end
end
