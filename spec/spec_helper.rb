require 'rspec'
RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

def catch_error(type, &block)
  yield
  nil
rescue type => e
  e
end

require_relative '../lib/taskmapper/providers/kanbanpad'
