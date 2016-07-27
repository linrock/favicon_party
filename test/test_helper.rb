require 'minitest/autorun'
require 'minitest/reporters'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'favicon_party'

def read_fixture(path, flags = "r")
  filename = "#{File.dirname(__FILE__)}/fixtures/#{path}"
  open(filename, flags).read
end


Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
