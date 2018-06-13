require 'test_helper'

class FetcherTest < Minitest::Test

  def setup
    test_url = "http://localhost"
    @fetcher = FaviconParty::Fetcher.new(test_url)
    @fetcher.final_url = test_url
  end

  def test_fetcher_raises_error_if_no_favicon_found
    @fetcher.candidate_urls = []
    assert_raises(FaviconParty::FaviconNotFound) do
      @fetcher.get_favicon_data
    end
  end

  def test_fetcher_finds_favicon_urls_in_html
    html = read_fixture("html/page1.html")
    assert @fetcher.find_favicon_urls_in_html(html).length == 2
  end

  def test_fetcher_does_not_url_encode_already_encoded_urls
    html = read_fixture("html/page1.html")
    url = @fetcher.find_favicon_urls_in_html(html)[1]
    assert url !~ /%2520/
  end

=begin
  def test_fetcher_decodes_base64_data_uri_links
    data = read_fixture("favicons/specimens/not_transparent.png", "rb")
    image = FaviconParty::Image.new(data)
    data_uri = "data:image/png;base64,#{image.base64_png}"
    assert @fetcher.get_favicon_data_from_url(data_uri) == image.source_data
  end
=end

  def test_fetcher_finds_location_headers_in_http_response
    @fetcher = FaviconParty::Fetcher.new("wevorce.com")
    location = @fetcher.final_location(read_fixture("http_headers/wevorce.com.txt"))
    assert location == "https://www.wevorce.com"
  end
end
