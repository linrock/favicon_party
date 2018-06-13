require 'base64'
require 'open3'
require 'mini_magick'

module FaviconParty

  # For handling anything related to the image data of the favicon itself
  #
  class Image
    include FaviconParty::Utils

    # Threshold for stdev of color values under which the image data
    # is considered one color
    #
    STDEV_THRESHOLD = 0.005

    MAX_FILE_SIZE = 1024 * 1024

    VALID_MIME_TYPES = %w(
      image/x-ico
      image/x-icon
      image/png
      image/gif
      image/svg+xml
      image/jpeg
      image/x-ms-bmp
    )

    attr_accessor :source_data, :png_data, :error

    def initialize(source_data)
      @source_data = source_data
      @png_data = nil
      @error = nil
    end

    def mime_type
      return @mime_type if defined? @mime_type
      @mime_type = get_mime_type(@source_data)
    end

    def identify(verbose = false)
      if verbose
        minimagick_image.identify "verbose"
      else
        minimagick_image.identify
      end
    end

    # Does the data look like a valid favicon?
    #
    def valid?(options = {})
      @error =
        if blank?
          "source_data is blank"
        elsif !valid_mime_type?
          "source_data mime-type is invalid - #{mime_type}"
        elsif one_pixel?
          "source_data is a 1x1 image"
        elsif size_too_big?
          "source_data file size too big"
        end
      @error.nil?
    end

    def blank?
      @source_data.nil? || @source_data.length <= 1
    end

    def size_too_big?
      size >= MAX_FILE_SIZE
    end

    # TODO set an option to decide how mime-type validity is handled
    #
    def invalid_mime_type?
      mime_type =~ /(text|html|x-empty|octet-stream|ERROR|zip|jar)/
    end

    def valid_mime_type?
      VALID_MIME_TYPES.include? mime_type
    end

    def one_pixel?
      files = identify.split(/\n/)
      files.length == 1 && files[0].include?(" 1x1 ")
    end

    # ex. 16x16
    def dimensions
      minimagick_image.dimensions
    end

    # number of bytes in the raw data
    #
    def size
      @source_data && @source_data.size || 0
    end

    def info_str
      "#{mime_type}, #{dimensions.join("x")}, #{size} bytes"
    end

    # Export source_data as a 16x16 png
    #
    def to_png
      return @png_data if !@png_data.nil?
      image = minimagick_image
      image.resize '16x16!'
      image.format 'png'
      image.strip
      @png_data = image.to_blob
      raise FaviconParty::InvalidData.new("Empty png") if @png_data.empty?
      @png_data
    end

    def base64_source_data
      Base64.encode64(@source_data).split(/\s+/).join
    end

    def base64_png
      Base64.encode64(to_png).split(/\s+/).join
    end

    def minimagick_image
      @minimagick_image ||= MiniMagick::Image.read(@source_data, '.ico')
    end

    def inspect
      %(#<FaviconParty::Image mime_type: "#{mime_type}", size: #{size}>)
    end
  end
end
