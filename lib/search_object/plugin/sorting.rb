module SearchObject
  module Plugin
    module Sorting
      def self.included(base)
        base.extend ClassMethods
        base.instance_eval do
          option :sort do |scope, value|
            scope.order "#{sort_attribute} #{sort_direction}"
          end
        end
      end

      def sort?(attribute)
        attribute == sort || sort.to_s.starts_with?("#{attribute} ")
      end

      def sort_attribute
        @sort_attribute ||= begin
          attribute = sort.to_s.split(' ', 2).first
          attribute = sort_attributes.first unless sort_attributes.include? attribute
          attribute
        end
      end

      def sort_direction
        @sort_direction ||= begin
          direction = sort.to_s.split(' ', 2).last
          direction = sort_directions.first unless sort_directions.include? direction
          direction
        end
      end

      private

      def sort_attributes
        self.class.sort_attributes
      end

      def sort_directions
        %w(desc asc)
      end

      module ClassMethods
        def sort_by(*attributes)
          @sort_attributes = attributes.map(&:to_s)
          @defaults['sort'] = "#{@sort_attributes.first} desc"
        end

        def sort_attributes
          @sort_attributes ||= []
        end
      end
    end
  end
end
