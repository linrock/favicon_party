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
    html = open("#{File.dirname(__FILE__)}/fixtures/html/page1.html").read
    assert @fetcher.find_favicon_urls_in_html(html).length == 1
  end

  def test_fetcher_decodes_base64_data_uri_links
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/transparent-16x16.png"
    image = FaviconParty::Image.new(open(filename, "rb").read)
    data_uri = "data:image/png;base64,#{image.base64_png}"
    assert @fetcher.get_favicon_data_from_url(data_uri) == image.source_data
  end

  def test_fetcher_finds_location_headers_in_http_response
    filename = "#{File.dirname(__FILE__)}/fixtures/http_headers/wevorce.com.txt"
    @fetcher = FaviconParty::Fetcher.new("wevorce.com")
    location = @fetcher.final_location(open(filename, "r").read)
    assert location == "https://www.wevorce.com"
  end

end
