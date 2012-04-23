require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ticketmaster-kanbanpad"
    gem.summary = %Q{Ticketmaster Provider for Kanbanpad}
    gem.description = %Q{Allows ticketmaster to interact with kanbanpad.}
    gem.email = "sonia@hybridgroup.com"
    gem.homepage = "http://github.com/hybridgroup/ticketmaster-kanbanpad"
    gem.authors = ["HybridGroup"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
      spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
    version = File.exist?('VERSION') ? File.read('VERSION') : ""

      rdoc.rdoc_dir = 'rdoc'
      rdoc.title = "ticketmaster-kanbanpad#{version}"
      rdoc.rdoc_files.include('README*')
      rdoc.rdoc_files.include('lib/**/*.rb')
end
