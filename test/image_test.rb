require 'test_helper'


class ImageTest < Minitest::Test

  def setup
    @klass = FaviconParty::Image
  end

  def test_nil_data_is_invalid
    @image = @klass.new nil
    assert @image.valid? == false
  end

  def test_transparent_png_is_invalid
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/transparent-16x16.png"
    @image = @klass.new open(filename, "rb").read
    assert @image.mime_type == "image/png"
    assert @image.transparent? == true
    assert @image.one_color? == true
    assert @image.valid? == false
  end

  def test_does_not_detect_jpeg_as_transparent
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/specimens/a_jpeg.jpg"
    @image = @klass.new open(filename, "rb").read
    assert @image.transparent? == false
    assert @image.valid? == true
  end

  def test_1x1_gif_is_invalid
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/transparent-1x1.gif"
    @image = @klass.new open(filename, "rb").read
    assert @image.mime_type == "image/gif"
    assert @image.one_pixel? == true
    assert @image.valid? == false
  end

  def test_all_white_ico_is_invalid
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/white-16x16.ico"
    @image = @klass.new open(filename, "rb").read
    assert %w( image/x-ico image/x-icon ).include? @image.mime_type
    assert @image.one_color? == true
    assert @image.valid? == false
  end

  def test_svg_mime_type_is_valid
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/white-16x16.svg"
    @image = @klass.new open(filename, "rb").read
    assert @image.one_color?
    assert @image.valid_mime_type?
  end

  def test_base64_png_works
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/white-16x16.ico"
    @image = @klass.new open(filename, "rb").read
    assert !@image.base64_png.nil?
  end

  def test_dimensions_returns_correct_dimensions
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/white-16x16.ico"
    @image = @klass.new open(filename, "rb").read
    assert @image.dimensions == "16x16"
  end

end
