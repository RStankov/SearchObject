module SearchObject
  module Plugin
    module WillPaginate
      include Paging

      private

      def apply_paging(scope)
        scope.paginate per_page: per_page, :page => page == 0 ? nil : page
      end
    end
  end
end
