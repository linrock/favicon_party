require 'test_helper'

class LoaderTest < Minitest::Test

  def setup
    @klass = FaviconParty::Loader
  end

  def test_loader_loads_favicon_images
    filename = "#{File.dirname(__FILE__)}/fixtures/favicons/transparent-16x16.png"
    image = @klass.load filename
    assert image.class == FaviconParty::Image
  end
end
