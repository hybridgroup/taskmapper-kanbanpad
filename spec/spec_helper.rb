require 'taskmapper-kanbanpad'
require 'rspec'

def fixture_for(name)
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + '.json')
end
