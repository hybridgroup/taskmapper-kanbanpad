# -*- encoding: utf-8 -*-
require File.expand_path('../lib/taskmapper-kanbanpad/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Omar Rodriguez", "Cored"]
  gem.email         = ["omarjavier15@gmail.com", "george.rafael@gmail.com"]
  gem.description   = %q{This is the provider for interaction with kanbanpad using taskmapper}
  gem.summary       = %q{This is the provider for interaction with kanbanpad using taskmapper}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "taskmapper-kanbanpad"
  gem.require_paths = ["lib"]
  gem.version       = Taskmapper::Kanbanpad::VERSION
  
  gem.add_development_dependency "rspec"
end
