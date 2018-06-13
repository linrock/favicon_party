require 'test_helper'

class HTTPClientTest < Minitest::Test
  include FaviconParty::Utils

  def setup
    @http_client = FaviconParty::HTTPClient
  end

  def test_curl_get_cmd_prefixes_urls
    url = "example.com"
    cmd = @http_client.curl_get_cmd(url)
    assert cmd.include?(prefix_url(url))
  end

  def test_curl_get_cmd_allows_prefixed_urls
    url = "http://example.com"
    cmd = @http_client.curl_get_cmd(url)
    assert cmd.include?(prefix_url(url))
  end

  def test_curl_head_cmd_prefixes_urls
    url = "example.com"
    cmd = @http_client.curl_head_cmd(url)
    assert cmd.include?(prefix_url(url))
  end

  def test_curl_head_cmd_allows_prefixed_urls
    url = "http://example.com"
    cmd = @http_client.curl_head_cmd(url)
    assert cmd.include?(prefix_url(url))
  end
end
