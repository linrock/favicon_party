require 'open3'


module FaviconParty

  # For now, wrap command-line curl rather than using net/http or open-uri
  # because of easier/more reliable SSL handling
  #
  module HTTPClient
    include FaviconParty::Utils

    TIMEOUT = 5

    # Encodes output as utf8 - Not for binary http responses
    #
    def get(url)
      stdin, stdout, stderr, t = Open3.popen3(curl_get_cmd(url))
      output = encode_utf8(stdout.read).strip
      error = encode_utf8(stderr.read).strip
      if !error.nil? && !error.empty?
        if error.include? "SSL"
          raise FaviconParty::Curl::SSLError.new(error)
        elsif error.include? "Couldn't resolve host"
          raise FaviconParty::Curl::DNSError.new(error)
        else
          raise FaviconParty::CurlError.new(error)
        end
      end
      output
    end

    # Get binary data from url and ignore errors
    #
    def bin_get(url)
      `#{curl_get_cmd(url)} 2>/dev/null`
    end

    def head(url)
      response_headers = `#{curl_head_cmd(url)}`
      encode_utf8 response_headers
    end

    def build_curl_cmd(url, flags = "")
      "curl #{curl_shared_flags} #{flags} '#{prefix_url(url, :downcase => false)}'"
    end

    def curl_get_cmd(url)
      build_curl_cmd url, "--compressed --fail --show-error"
    end

    def curl_head_cmd(url)
      build_curl_cmd url, "-I -1"
    end

    private

    def curl_shared_flags
      "-sL -k -m #{TIMEOUT} --ciphers 'RC4,3DES,ALL'"
    end

    extend self
  end

end
