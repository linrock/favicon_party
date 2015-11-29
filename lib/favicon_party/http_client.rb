require 'open3'


module FaviconParty

  module HTTPClient
    include FaviconParty::Utils

    TIMEOUT = 5

    def curl_cmd(url)
      "curl -sL -k --compressed -m #{TIMEOUT} --ciphers 'RC4,3DES,ALL' --fail --show-error '#{url}'"
    end

    # Encodes output as utf8 - Not for binary http responses
    #
    def get(url)
      stdin, stdout, stderr, t = Open3.popen3(curl_cmd(url))
      output = encode_utf8(stdout.read).strip
      error = encode_utf8(stderr.read).strip
      if !error.nil? && !error.empty?
        if err.include? "SSL"
          raise FaviconParty::Curl::SSLError.new(err)
        elsif err.include? "Couldn't resolve host"
          raise FaviconParty::Curl::DNSError.new(err)
        else
          raise FaviconParty::CurlError.new(err)
        end
      end
      output
    end

    # Get binary data from url and ignore errors
    #
    def bin_get(url)
      `#{curl_cmd(url)} 2>/dev/null`
    end

    def head(url)
      headers = `curl -sIL -1 --ciphers 'RC4,3DES,ALL' -m #{TIMEOUT} "#{url}"`
      encode_utf8 headers
    end

    extend self
  end

end
