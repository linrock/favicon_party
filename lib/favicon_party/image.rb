require 'open3'


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
    )

    attr_accessor :source_data, :png_data, :error

    def initialize(source_data)
      @source_data = source_data
      @png_data = nil
      @error = nil
    end

    def imagemagick_run(cmd, binmode = false)
      stdin, stdout, stderr, t = Open3.popen3(cmd)
      stdout.binmode if binmode
      output = stdout.read.strip
      error = stderr.read.strip
      if output.empty? && !error.nil? && !error.empty?
        raise FaviconParty::ImageMagickError.new(error)
      end
      output
    end

    def mime_type
      return @mime_type if defined? @mime_type
      @mime_type = get_mime_type(@source_data)
    end

    def identify(verbose = false)
      with_temp_data_file(@source_data) do |t|
        imagemagick_run("identify #{"-verbose" if verbose} #{t.path.to_s}")
      end
    end

    # Does the data look like a valid favicon?
    #
    def valid?
      @error =
        if blank?
          "source_data is blank"
        elsif size_too_big?
          "source_data file size too big"
        elsif !valid_mime_type?
          "source_data mime-type is invalid - #{mime_type}"
        elsif transparent?
          "source_data is a transparent image"
        elsif one_pixel?
          "source_data is a 1x1 image"
        elsif one_color?
          "png_data is one color (or close to it)"
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

    def transparent?
      with_temp_data_file(@source_data) do |t|
        cmd = "convert #{t.path.to_s} -channel a -negate -format '%[mean]' info:"
        imagemagick_run(cmd).to_i == 0
      end
    end

    def one_pixel?
      files = identify.split(/\n/)
      files.length == 1 && files[0].include?(" 1x1 ")
    end

    def one_color?
      colors_stdev < STDEV_THRESHOLD
    end

    def colors_stdev
      with_temp_data_file(to_png) do |t|
        cmd = "identify -format '%[fx:image.standard_deviation]' #{t.path.to_s}"
        imagemagick_run(cmd).to_f
      end
    end

    def n_colors
      with_temp_data_file(@source_data) do |t|
        cmd = "identify -format '%k' #{t.path.to_s}"
        imagemagick_run(cmd).to_i
      end
    end

    def dimensions
      with_temp_data_file(@source_data) do |t|
        cmd = "convert #{t.path.to_s}[0] -format '%wx%h' info:"
        imagemagick_run(cmd)
      end
    end

    # number of bytes in the raw data
    #
    def size
      @source_data && @source_data.size || 0
    end

    def info_str
      "#{mime_type}, #{dimensions}, #{size} bytes"
    end

    # Export source_data as a 16x16 png
    #
    def to_png
      return @png_data if !@png_data.nil?
      with_temp_data_file(@source_data) do |t|
        sizes = imagemagick_run("identify #{t.path.to_s}").split(/\n/)
        images = []
        %w(16x16 32x32 64x64).each do |dims|
          %w(32-bit 24-bit 16-bit 8-bit).each do |bd|
            images += sizes.select {|x| x.include?(dims) and x.include?(bd) }.
                           map     {|x| x.split(' ')[0] }
          end
        end
        image_to_convert = images.uniq[0] || "#{t.path.to_s}[0]"
        cmd = "convert -strip -resize 16x16! #{image_to_convert} png:fd:1"
        @png_data = imagemagick_run(cmd, true)
        raise FaviconParty::InvalidData.new("Empty png") if @png_data.empty?
        @png_data
      end
    end

    def base64_source_data
      Base64.encode64(@source_data).split(/\s+/).join
    end

    def base64_png
      Base64.encode64(to_png).split(/\s+/).join
    end

    def inspect
      %(#<FaviconParty::Image mime_type: "#{mime_type}", size: #{size}>)
    end

  end

end
