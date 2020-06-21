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

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rspec-mocks', '~> 3.5'
  spec.add_development_dependency 'activerecord', '~> 5.0'
  spec.add_development_dependency 'actionpack', '~> 5.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'will_paginate'
  spec.add_development_dependency 'kaminari'
  spec.add_development_dependency 'kaminari-activerecord'
  spec.add_development_dependency 'rubocop', '0.81.0'
  spec.add_development_dependency 'rubocop-rspec', '1.38.1'
end
