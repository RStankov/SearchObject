# frozen_string_literal: true

module SearchObject
  module Plugin
    module Sorting
      def self.included(base)
        base.extend ClassMethods
        base.instance_eval do
          option :sort do |scope, _|
            scope.order sort_attribute => sort_direction
          end
        end
      end

      def sort?(attribute)
        attribute == sort || sort.to_s.starts_with?("#{attribute} ")
      end

      def sort_attribute
        @sort_attribute ||= Helper.ensure_included sort.to_s.split(' ', 2).first, self.class.sort_attributes
      end

      def sort_direction
        @sort_direction ||= Helper.ensure_included sort.to_s.split(' ', 2).last, %w[desc asc]
      end

      def sort_direction_for(attribute)
        if sort_attribute == attribute.to_s
          reverted_sort_direction
        else
          'desc'
        end
      end

      def sort_params_for(attribute, options = {})
        options['sort'] = "#{attribute} #{sort_direction_for(attribute)}"
        params options
      end

      def reverted_sort_direction
        sort_direction == 'desc' ? 'asc' : 'desc'
      end

      module ClassMethods
        def sort_by(*attributes, default: nil)
          config[:sort_attributes]  = attributes.map(&:to_s)
          config[:defaults]['sort'] = default || "#{config[:sort_attributes].first} desc"
        end

        def sort_attributes
          config[:sort_attributes] ||= []
        end
      end
    end
  end
end
