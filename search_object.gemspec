# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'search_object/version'

Gem::Specification.new do |spec|
  spec.name          = "search_object"
  spec.version       = SearchObject::VERSION
  spec.authors       = ["Radoslav Stankov"]
  spec.email         = ["rstankov@gmail.com"]
  spec.description   = %q{Search object DSL}
  spec.summary       = %q{Provides DSL for creating search objects}
  spec.homepage      = "https://github.com/RStankov/SearchObject"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rspec-mocks', '>= 2.12.3'
  spec.add_development_dependency 'activerecord', '>= 3.0.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'active_model_lint-rspec'
  spec.add_development_dependency 'will_paginate'
  spec.add_development_dependency 'kaminari'
end
