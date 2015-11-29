require 'test_helper'


class FetcherTest < Minitest::Test

  def setup
    test_url = "http://localhost"
    @fetcher = FaviconParty::Fetcher.new(test_url)
    @fetcher.final_url = test_url
  end

  def test_fetcher_finds_favicon_urls_in_html
    html = open("#{File.dirname(__FILE__)}/fixtures/html/page1.html").read
    assert @fetcher.find_favicon_urls_in_html(html).length == 1
  end

  def test_fetcher_detects_data_uri_links
    data_uri = "data:image/png,"
    assert @fetcher.get_favicon_data_from_url(data_uri) == nil
  end

end
