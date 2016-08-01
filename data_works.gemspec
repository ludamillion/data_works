# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "data_works/version"

Gem::Specification.new do |s|
  s.name          = "data_works"
  s.version       = DataWorks::VERSION
  s.authors       = ["Wyatt Greene", "Anne Geiersbach", "Dennis Chan", "Luke Inglis"]
  s.email         = ["ld.inglis@gmail.com"]
  s.summary       = %q{Reducing the complexity of testing complex data models }
  s.description   = %q{DataWorks makes it easier to work with FactoryGirl in the context of a complex data model.}
  s.homepage      = 'https://github.com/dmcouncil/data_works'
  s.licenses      = ["Copyright (c) 2014 District Management Council"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", "= 4.1.12"
  s.add_dependency 'factory_girl', '>= 3.0'
  s.add_dependency 'graphviz', '~> 0.1.0'
  s.add_dependency 'launchy', '~> 2.4'

  s.add_development_dependency "bundler", "~> 1.9"
  s.add_development_dependency "rake", "~> 10.4"
  s.add_development_dependency "database_cleaner", "~> 1.4.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
end
