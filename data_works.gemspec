lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'data_works/version'

def add_dependencies(spec)
  spec.add_dependency 'activerecord', '~> 4.1'
  spec.add_dependency 'activesupport', '~> 4.1'
  spec.add_dependency 'factory_girl', '>= 3.0'
  spec.add_dependency 'graphviz', '~> 0.1.0'
  spec.add_dependency 'launchy', '~> 2.4'
end

def add_development_dependencies(spec)
  spec.add_development_dependency 'active_hash', '~> 1.5.0'
  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'database_cleaner', '~> 1.4.0'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'sqlite3'
end

Gem::Specification.new do |s|
  s.name          = 'data_works'
  s.version       = DataWorks::VERSION
  s.authors       = ['Wyatt Greene', 'Anne Geiersbach', 'Dennis Chan', 'Luke Inglis']
  s.email         = ['ld.inglis@gmail.com']
  s.summary       = 'Reducing the complexity of testing complex data models'
  s.description   = 'DataWorks makes it easier to work with FactoryBot in the context of a complex data model.'
  s.homepage      = 'https://github.com/ludamillion/data_works'
  s.licenses      = ['MIT', 'Copyright (c) 2018 District Management Group']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", "~> 4.1"
  s.add_dependency "activesupport", "~> 4.1"
  s.add_dependency 'factory_bot', '>= 4.8'
  s.add_dependency 'graphviz', '~> 0.1.0'
  s.add_dependency 'launchy', '~> 2.4'

  add_dependencies(s)
  add_development_dependencies(s)
end
