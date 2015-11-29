module FaviconParty

  class CurlError < StandardError; end

  module Curl
    class DNSError < CurlError; end
    class SSLError < CurlError; end
  end

  class FaviconNotFound < StandardError; end

  class Error < StandardError
    attr_accessor :meta

    def initialize(message)
      @meta = {}
      super(message)
    end

    def to_h
      {
        :error_class    => self.class.to_s,
        :error_message  => self.message
      }.merge(meta)
    end

  end

  class InvalidData < StandardError; end
  class ImageMagickError < Error; end

end
