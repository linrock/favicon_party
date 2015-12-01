![Favicon Party](https://cloud.githubusercontent.com/assets/208617/11496590/d4b1f6dc-97c7-11e5-8e09-e61e50274e31.png)

Fetch favicons from webpages and convert them into various image formats!


## Installation

You can install FaviconParty through [RubyGems](https://rubygems.org/)

```
$ gem install favicon_party
```

Or add it to your application's Gemfile and install via bundler

```
gem 'favicon_party'
```


## Fetching favicon images

FaviconParty parses the html response of the query url to find favicon
links and falls back to checking /favicon.ico

```ruby
image = FaviconParty.fetch! "github.com"
#  => #<FaviconParty::Image mime_type: "image/x-icon", size: 6518>
```

If a valid favicon isn't found:

```ruby
FaviconParty.fetch! "http://example.com"    # raises FaviconNotFound
FaviconParty.fetch  "http://example.com"    # nil
```


## Converting favicon images

To access the source favicon data and convert it into various image formats:

```ruby
image.source_data   # binary favicon image data
image.to_png        # binary 16x16 png data
image.base64_png    # base64-encoded 16x16 png data
```


## Loading favicon images

You can load favicon data from image files:

```ruby
image = FaviconParty.load "/path/to/favicon.ico"
#  => #<FaviconParty::Image mime_type: "image/x-icon", size: 6518>

image.valid?  # true
```

And also load them directly from their source URLs:

```ruby
image = FaviconParty.load "https://github.com/favicon.ico"
#  => #<FaviconParty::Image mime_type: "image/x-icon", size: 6518>
```


## Command-line client

FaviconParty also provides a command-line script for fetching favicons. By
default, it attempts to fetch a favicon from the given URL and prints it to stdout.
Run `fetch_favicon --help` to see the list of options.

```bash
fetch_favicon github.com                  # prints favicon data to STDOUT
fetch_favicon --format png github.com     # prints 16x16 favicon png to STDOUT
fetch_favicon example.com                 # prints an error to STDERR
```


## Requirements

* Ruby 2.0.0+
* [Nokogiri](https://github.com/sparklemotion/nokogiri) - parsing html
* [Imagemagick](http://www.imagemagick.org/) - validating and converting favicons
* [Curl](http://curl.haxx.se/) - http client
* [File](http://darwinsys.com/file/) - mime-type detection
