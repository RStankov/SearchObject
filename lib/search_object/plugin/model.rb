# frozen_string_literal: true

module SearchObject
  module Plugin
    module Model
      def self.included(base)
        base.class_eval do
          include ActiveModel::Conversion
          extend ActiveModel::Naming
        end
      end

      def persisted?
        false
      end
    end
  end
end
