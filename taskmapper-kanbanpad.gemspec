# -*- encoding: utf-8 -*-
require File.expand_path('../lib/taskmapper/providers/kanbanpad/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ["Omar Rodriguez", "Cored"]
  s.email         = ["omarjavier15@gmail.com", "george.rafael@gmail.com"]
  s.description   = %q{This is the provider for interaction with kanbanpad using taskmapper}
  s.summary       = %q{Kanbanpad TaskMapper provider}
  s.homepage      = "https://github.com/hybridgroup/taskmapper-kanbanpad"

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.name          = "taskmapper-kanbanpad"
  s.require_paths = ["lib"]
  s.version       = TaskMapper::Providers::Kanbanpad::VERSION
  
  s.add_development_dependency "taskmapper", "2.0.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "rubygems-bundler"
  s.add_development_dependency "libnotify"
end
