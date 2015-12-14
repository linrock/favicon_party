require 'minitest/autorun'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'favicon_party'


def read_fixture(path, flags = "r")
  filename = "#{File.dirname(__FILE__)}/fixtures/#{path}"
  open(filename, flags).read
end
