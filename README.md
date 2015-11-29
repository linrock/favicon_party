# Favicon Party

Fetch favicons from websites and convert them into other image formats!


## Fetching favicon images

Favicon Party parses the html response of the query url to find favicon
links, and falls back to checking /favicon.ico for valid favicon images.

```ruby
image = FaviconParty.fetch! "https://github.com"

# => #<FaviconParty::Image mime_type: "image/x-icon", size: 6518>

image.valid?        # true
image.source_data   # binary favicon image data
image.to_png        # binary 16x16 png data
image.base64_png    # base64-encoded 16x16 png data


FaviconParty.fetch! "http://example.com"    # raises FaviconNotFound
FaviconParty.fetch  "http://example.com"    # nil
```


## Loading favicon images

You can load favicon files directly as well.

```ruby
image = FaviconParty.load "/path/to/favicon.ico"

# => #<FaviconParty::Image mime_type: "image/x-icon", size: 6518>
```

Same for loading favicon URLs.

```ruby
image = FaviconParty.load "https://github.com/favicon.ico"

# => #<FaviconParty::Image mime_type: "image/x-icon", size: 6518>
```


## Command-line client

Favicon Party also provides a command-line script for fetching favicons. By
default, it attempts to fetch a favicon from the given URL and prints it out.
Run `fetch_favicon --help` to see the list of options.

```bash
fetch_favicon github.com                  # prints favicon data to STDOUT
fetch_favicon --format png github.com     # prints 16x16 favicon png to STDOUT
fetch_favicon example.com                 # prints an error to STDERR
```


## Installation

The best way to install Favicon Party is through [RubyGems](https://rubygems.org/)

```
$ gem install favicon_party
```


## Requirements

* Ruby 2.0.0+
* [Nokogiri](https://github.com/sparklemotion/nokogiri) - parsing html
* [Imagemagick](http://www.imagemagick.org/) - validating and converting favicons
* [Curl](http://curl.haxx.se/) - http client
* [File](http://darwinsys.com/file/) - mime-type detection
