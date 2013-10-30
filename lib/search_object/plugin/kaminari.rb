module SearchObject
  module Plugin
    module Kaminari
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
        super.page(@page).per(per_page)
      end
    end
  end
end

