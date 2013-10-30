module SearchObject
  module Plugin
    module WillPaginate
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
        super.paginate per_page: per_page, :page => @page == 0 ? nil : @page
      end
    end
  end
end
