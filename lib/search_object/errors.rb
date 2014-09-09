module SearchObject
  class MissingScopeError < ArgumentError
    def initialize
      super 'No scope provided. Scope can be defined on a class level or passed as an option.'
    end
  end

  class InvalidNumberError < ArgumentError
    def initialize(field, number)
      super "#{field} should be more than 0. Currently '#{number}' is given."
    end
  end
end
