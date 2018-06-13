# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'favicon_party/version'


Gem::Specification.new do |s|
  s.name           = "favicon_party"
  s.version        = FaviconParty::VERSION
  s.authors        = ["Linmiao Xu"]
  s.email          = ["linmiao.xu@gmail.com"]

  s.summary        = "Fetch favicons from webpages and have a blast!"
  s.description    = "Fetch favicons from webpages and have a blast!"
  s.homepage       = "https://github.com/linrock/favicon_party"
  s.license        = "MIT"

  s.files          = `git ls-files -z`.split("\0")
  s.bindir         = "bin"
  s.executables    = ["fetch_favicon"]
  s.require_paths  = ["lib"]

  s.add_development_dependency "rake",               "~> 10.0"
  s.add_development_dependency "minitest",           "~> 5.0"
  s.add_development_dependency "minitest-reporters", "~> 1.1"
  s.add_development_dependency "pry",                "~> 0.10"

  s.add_dependency "nokogiri", "~> 1.8"
  s.add_dependency "mini_magick", "~> 4.8"
end
