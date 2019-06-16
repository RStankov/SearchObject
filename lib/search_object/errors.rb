# frozen_string_literal: true

module SearchObject
  class MissingScopeError < ArgumentError
    def initialize(message = 'No scope provided. Scope can be defined on a class level or passed as an option.')
      super message
    end
  end

  class InvalidNumberError < ArgumentError
    attr_reader :field, :number

    def initialize(field, number)
      @field  = field
      @number = number

      super "#{field} should be more than 0. Currently '#{number}' is given."
    end
  end
end
