require 'test_helper'

class UtilsTest < Minitest::Test
  include FaviconParty::Utils

  def test_get_mime_type_detects_png_correctly
    data = read_fixture("favicons/transparent-16x16.png", "rb")
    assert get_mime_type(data) == "image/png"
  end

  def test_get_mime_type_detects_gif_correctly
    data = read_fixture("favicons/transparent-1x1.gif", "rb")
    assert get_mime_type(data) == "image/gif"
  end

  def test_get_mime_type_detects_ico_correctly
    data = read_fixture("favicons/white-16x16.ico", "rb")
    assert %w( image/x-ico image/x-icon ).include? get_mime_type(data)
  end

  def test_get_mime_type_detects_svg_correctly
    data = read_fixture("favicons/white-16x16.svg", "rb")
    assert get_mime_type(data) == "image/svg+xml"
  end

  def test_get_mime_type_detects_html_correctly
    assert get_mime_type(read_fixture("html/page1.html")) == "text/html"
  end

  def test_prefix_url_always_returns_prefixed_urls
    assert prefix_url("localhost") =~ /\Ahttp:\/\//
    assert prefix_url("http://localhost") =~ /\Ahttp:\/\//
  end

  def test_prefix_url_does_not_downcase_when_a_flag_is_set
    assert prefix_url("localhost/tEsT", :downcase => false) =~ /\/tEsT/
    assert prefix_url("localhost/tEsT") =~ /\/test/
  end

  def test_encode_utf8_returns_valid_utf8_string
    string = "\x12\x61\xA3"
    assert !string.valid_encoding?
    assert encode_utf8(string).valid_encoding?
  end

  def test_prefix_url_does_not_reencode_encoded_url
    url = "http://cdn6.bigcommerce.com/s-xe95b6v/product_images/Beep_SocialMedia_1%20(2).jpg"
    assert WEBrick::HTTPUtils.unescape(url) != url
    assert prefix_url(url, :downcase => false) == url
  end
end
