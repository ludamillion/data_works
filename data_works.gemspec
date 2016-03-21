# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "data_works/version"

Gem::Specification.new do |s|
  s.name          = "data_works"
  s.version       = DataWorks::VERSION
  s.authors       = ["Wyatt Greene", "Anne Geiersbach", "Dennis Chan", "Luke Inglis"]
  s.email         = ["ld.inglis@gmail.com"]
  s.summary       = %q{Reducing the complexity of testing complex data models }
  s.description   = %q{DataWorks makes it easier to work with FactoryGirl in the context of a complex data model.}
  s.licenses      = ["Copyright (c) 2014 District Management Council"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'factory_girl', '~> 3.0'

end
