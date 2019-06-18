# frozen_string_literal: true

module SearchObject
  module Plugin
    module Kaminari
      include Paging

      def self.included(base)
        base.extend Paging::ClassMethods
      end

      private

      def apply_paging(scope)
        scope.page(page).per(per_page)
      end
    end
  end
end
