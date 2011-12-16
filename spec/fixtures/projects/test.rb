require 'rubygems'
require 'crack'
require 'json'

xml = Crack::XML.parse(File.read('create.xml'))
json = xml.to_json
puts json
