# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'serps/version'

Gem::Specification.new do |spec|
  spec.name          = 'serps'
  spec.version       = Serps::VERSION
  spec.authors       = ['3141592653']
  spec.email         = ['circleratio10@gmail.com']
  spec.summary       = 'SERPs API'
  spec.description   = 'SERPs API'
  spec.homepage      = 'https://github.com/3141592653/serps'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.28'

  spec.add_development_dependency 'guard', '~> 2.11'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2'

  spec.add_development_dependency 'rspec'

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'mechanize', '~> 2.7'
  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'ruby-progressbar', '~> 1.7'
end
