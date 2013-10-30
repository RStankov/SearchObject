module SearchObject
  module Plugin
    module Kaminari
      include Paging

      private

      def apply_paging(scope)
        scope.page(page).per(per_page)
      end
    end
  end
end

