module SearchObject
  class MissingScopeError < RuntimeError
    def initialize
      super 'No scope provided. Scope can be defined on a class level or passed as an option.'
    end
  end
end
