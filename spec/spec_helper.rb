require 'taskmapper-kanbanpad'
require 'rspec'
require 'fakeweb'
require 'cgi'

FakeWeb.allow_net_connect = false

def fixture_for(name)
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + '.json')
end

def fixture_file(filename)
  return '' if filename == ''
  path = File.expand_path("#{File.dirname(__FILE__)}/fixtures/#{filename}.json")
  File.read path
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

def stub_request(method, url, filename, status = nil, content_type = 'application/json')
  options = {:body => ""}
  options.merge!({:body => fixture_file(filename)}) if filename
  options.merge!({:body => status.last}) if status.is_a?(Array)
  options.merge!({:status => status}) if status
  options.merge!({:content_type => content_type})

  url = "https://#{CGI.escape username}:#{password}@www.kanbanpad.com/api/v1" + url

  FakeWeb.register_uri method, url, options
end

def stub_get(*args) ; stub_request(:get, *args) end
def stub_post(*args); stub_request(:post, *args) end
def stub_put(*args); stub_request(:put, *args) end
def stub_delete(*args); stub_request(:delete, *args) end

RSpec.configure do |c|
  c.before do
    stub_get '/projects.json', 'projects'
    stub_get '/projects/be74b643b64e3dc79aa0.json', 'projects/be74b643b64e3dc79aa0'
    stub_get '/projects/be74b643b64e3dc79aa0/comments.json', 'comments'
    stub_get '/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007.json', 'tasks/4cd428c496f0734eef000007'
    stub_get '/projects/be74b643b64e3dc79aa0/tasks.json?backlog=yes&finished=yes', 'tasks'
    stub_get '/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007.json', 'tasks/4cd428c496f0734eef000007'
    stub_get '/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007/comments.json', 'comments'
    stub_get '/projects/be74b643b64e3dc79aa0/tasks/4dc31c4c9bd0ff6c3700004e.json', 'tasks/4dc31c4c9bd0ff6c3700004e'
    stub_post '/projects/be74b643b64e3dc79aa0/comments.json', ''
    stub_post '/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007/comments.json', ''
    stub_post '/projects/be74b643b64e3dc79aa0/tasks.json', ''
    stub_put '/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007.json', 'tasks/4cd428c496f0734eef000007'
  end
end
