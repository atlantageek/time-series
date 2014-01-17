Gem::Specification.new do |spec|
  spec.name        = 'time-series'
  spec.version     = '0.0.0'
  spec.author      = 'Eric Yan'
  spec.email       = 'long@ericyan.me'
  spec.homepage    = 'https://github.com/ericyan/time-series'
  spec.summary     = 'A Ruby library for dealing with time series data'
  spec.description = 'This library provides a basic data structure that can represent time series data. Requires Ruby version >= 1.9.2.'
  spec.license     = 'MIT'

  # Starting 1.9.2 hash insert order will be preserved
  spec.required_ruby_version = '>= 1.9.2'

  spec.add_development_dependency 'rspec'

  spec.files       = `git ls-files -z`.split("\x0")
  spec.test_files  = spec.files.grep(%r{^spec/})

  spec.require_paths = ["lib"]
end
