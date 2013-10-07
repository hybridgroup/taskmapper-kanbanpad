require 'taskmapper-kanbanpad'
require 'rspec'

def fixture_for(name)
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + '.json')
end

def username
  'abc@g.com'
end

def password
  'ie823d63js'
end

def create_instance(u = username, p = password)
  TaskMapper.new(:kanbanpad, :username => u, :password => p)
end
