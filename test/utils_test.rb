require 'test_helper'


class UtilsTest < Minitest::Test
  include FaviconParty::Utils

  def test_get_mime_type_detects_png_correctly
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/transparent-16x16.png"
    assert get_mime_type(open(filename, "rb").read) == "image/png"
  end

  def test_get_mime_type_detects_gif_correctly
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/transparent-1x1.gif"
    assert get_mime_type(open(filename, "rb").read) == "image/gif"
  end

  def test_get_mime_type_detects_ico_correctly
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/white-16x16.ico"
    assert %w( image/x-ico image/x-icon ).include? get_mime_type(open(filename, "rb").read)
  end

  def test_get_mime_type_detects_svg_correctly
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/white-16x16.svg"
    assert get_mime_type(open(filename, "rb").read) == "image/svg+xml"
  end

  def test_get_mime_type_detects_html_correctly
    filename = "#{File.dirname(__FILE__)}/fixtures/html/page1.html"
    assert get_mime_type(open(filename, "rb").read) == "text/html"
  end

  def test_prefix_url_always_returns_prefixed_urls
    assert prefix_url("localhost") =~ /\Ahttp:\/\//
    assert prefix_url("http://localhost") =~ /\Ahttp:\/\//
  end

  def test_encode_utf8_returns_valid_utf8_string
    string = "\x12\x61\xA3"
    assert !string.valid_encoding?
    assert encode_utf8(string).valid_encoding?
  end

end
