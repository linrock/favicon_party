require 'favicon_party/utils'
require 'favicon_party/errors'
require 'favicon_party/http_client'
require 'favicon_party/image'
require 'favicon_party/fetcher'
require 'favicon_party/loader'
require 'favicon_party/version'


module FaviconParty

  class << self

    def fetch!(url, options = {})
      Fetcher.new(url, options).fetch
    end

    def fetch(url)
      fetch!(url) rescue nil
    end

    def load(url_or_filename)
      Loader.load url_or_filename
    end

  end

end