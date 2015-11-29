require 'open-uri'


module FaviconParty

  module Loader

    def self.load(url_or_filename)
      Image.new open(url_or_filename, "rb").read
    end

  end

end
