require 'uri'
require 'tempfile'


module FaviconParty
  
  module Utils

    def prefix_url(url, options = {})
      unless options[:downcase] == false
        url = URI.encode url.strip.downcase
      else
        url = URI.encode url.strip
      end
      if url =~ /https?:\/\//
        url
      else
        "http://#{url}"
      end
    end

    def encode_utf8(text)
      return text if text.valid_encoding?
      text.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => '')
    end

    def get_mime_type(data, use_file_cmd = true)
      if use_file_cmd
        with_temp_data_file(data) {|t| `file -b --mime-type #{t.path.to_s}`.strip }
      else
        FileMagic.new(:mime_type).buffer(data)
      end
    end

    def with_temp_data_file(data, &block)
      begin
        t = Tempfile.new(["favicon", ".ico"])
        t.binmode
        t.write data
        t.close
        result = block.call(t)
      ensure
        t.unlink
      end
      result
    end

    extend self
  end

end
