# frozen_string_literal: true

module SearchObject
  module Plugin
    module Paging
      def self.included(base)
        base.extend ClassMethods
      end

      attr_reader :page, :per_page

      def initialize(options = {})
        @page     = [options[:page].to_i, 0].max
        @per_page = self.class.calculate_per_page options[:per_page]

        super options
      end

      private

      def fetch_results
        apply_paging super
      end

      def apply_paging(scope)
        scope.limit(per_page).offset(([page, 1].max - 1) * per_page)
      end

      module ClassMethods
        def per_page(number)
          raise InvalidNumberError.new('Per page', number) unless number.positive?

          config[:per_page] = number
        end

        def min_per_page(number)
          raise InvalidNumberError.new('Min per page', number) unless number.positive?

          config[:min_per_page] = number
        end

        def max_per_page(number)
          raise InvalidNumberError.new('Max per page', number) unless number.positive?

          config[:max_per_page] = number
        end

        # :api: private
        def calculate_per_page(given)
          per_page = (given || config[:per_page] || 25).to_i.abs
          per_page = [per_page, config[:max_per_page]].min if config[:max_per_page]
          per_page = [per_page, config[:min_per_page]].max if config[:min_per_page]
          per_page
        end
      end
    end
  end
end
