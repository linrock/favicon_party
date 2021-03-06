require 'test_helper'

class ImageTest < Minitest::Test

  def setup
    @klass = FaviconParty::Image
  end

  def test_nil_data_is_invalid
    @image = @klass.new nil
    assert @image.valid? == false
  end

  def test_does_not_detect_jpeg_as_transparent
    @image = @klass.new read_fixture("favicons/specimens/a_jpeg.jpg", "rb")
    assert @image.mime_type == "image/jpeg"
    assert @image.valid? == true
  end

  def test_1x1_gif_is_invalid
    @image = @klass.new read_fixture("favicons/transparent-1x1.gif", "rb")
    assert @image.mime_type == "image/gif"
    assert @image.one_pixel?
    assert @image.valid? == false
  end

  def test_svg_mime_type_is_valid
    @image = @klass.new read_fixture("favicons/white-16x16.svg")
    assert @image.valid_mime_type?
    assert @image.valid?(:no_color_check => true)
  end

  def test_x_ms_bmp_is_valid
    @image = @klass.new read_fixture("favicons/specimens/x-ms-bmp.ico")
    assert @image.mime_type == "image/bmp"
    assert @image.valid_mime_type?
  end

  def test_base64_png_works
    @image = @klass.new read_fixture("favicons/white-16x16.ico")
    assert !@image.base64_png.nil?
  end

  def test_dimensions_returns_correct_dimensions
    @image = @klass.new read_fixture("favicons/white-16x16.ico")
    assert @image.dimensions.join("x") == "16x16"
  end
end
