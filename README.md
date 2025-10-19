# robotstxt-rb

[![Gem Version](https://badge.fury.io/rb/robotstxt-rb.svg)](https://badge.fury.io/rb/robotstxt-rb)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Build Status](https://github.com/jacksontrieu/robotstxt-rb/workflows/CI/badge.svg)](https://github.com/jacksontrieu/robotstxt-rb/actions)
[![Ruby Version](https://img.shields.io/badge/ruby-%3E%3D%202.0-brightgreen.svg)](https://www.ruby-lang.org/)

A Ruby gem providing native bindings to Google's official C++ robots.txt parser and matcher. Enables fast, standards-compliant robots.txt parsing and URL access checking directly from Ruby.

## Features

- **Fast Performance**: Native C++ implementation via FFI bindings
- **Standards Compliant**: Wraps [Google's official robots.txt C++ parser](https://github.com/google/robotstxt)
- **Cross-Platform**: Supports macOS and Linux (ARM64 and x86_64)
- **Simple API**: Easy-to-use Ruby interface
- **RFC 9309 Compliant**: Follows the latest robots.txt specification

## Installation

### From RubyGems (Recommended)

```bash
gem install robotstxt-rb
```

### From GitHub

Add this line to your application's Gemfile:

```ruby
gem 'robotstxt-rb', git: 'https://github.com/jacksontrieu/robotstxt-rb.git'
```

And then execute:

```bash
bundle install
```

## Quick Start

```ruby
require 'robotstxt-rb'

# Check if a URL is allowed for a specific user agent
robots_txt = <<~ROBOTS
  User-agent: *
  Disallow: /admin
  Allow: /public
ROBOTS

# Check if a URL is allowed
RobotstxtRb.allowed?(
  robots_txt: robots_txt,
  user_agent: "MyBot",
  url: "https://example.com/public"
)
# => true

RobotstxtRb.allowed?(
  robots_txt: robots_txt,
  user_agent: "MyBot",
  url: "https://example.com/admin"
)
# => false

# Validate robots.txt content
RobotstxtRb.valid?(robots_txt: robots_txt)
# => true
```

## API Documentation

### `RobotstxtRb.allowed?(robots_txt:, user_agent:, url:)`

Checks if a specific URL is allowed to be crawled by a given user agent according to the robots.txt rules.

**Parameters:**
- `robots_txt` (String): The robots.txt content to parse
- `user_agent` (String): The user agent string to check
- `url` (String): The URL to check (can be full URL or path)

**Returns:** `Boolean` - `true` if the URL is allowed, `false` if disallowed

**Raises:** `ArgumentError` if any required parameter is `nil`

### `RobotstxtRb.valid?(robots_txt:)`

Validates whether the given robots.txt content is well-formed.

**Parameters:**
- `robots_txt` (String): The robots.txt content to validate

**Returns:** `Boolean` - `true` if valid, `false` if invalid or `nil`

## Supported Platforms

- **macOS**: ARM64 (Apple Silicon) and x86_64 (Intel)
- **Linux**: ARM64 and x86_64

## Usage Examples

### Basic URL Checking

```ruby
require 'robotstxt-rb'

# Simple robots.txt
robots_txt = "User-agent: *\nDisallow: /private"

# Check various URLs
puts RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "Bot", url: "/public")     # true
puts RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "Bot", url: "/private")    # false
puts RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "Bot", url: "/private/")   # false
```

### User Agent Specific Rules

```ruby
robots_txt = <<~ROBOTS
  User-agent: Googlebot
  Disallow: /search
  Allow: /

  User-agent: *
  Disallow: /
ROBOTS

# Googlebot can access most URLs
RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "Googlebot", url: "/")           # true
RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "Googlebot", url: "/search")     # false

# Other bots are blocked
RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "OtherBot", url: "/")            # false
```

### Wildcard Patterns

```ruby
robots_txt = <<~ROBOTS
  User-agent: *
  Disallow: /*.pdf$
  Disallow: /temp*
  Allow: /temp/public
ROBOTS

# PDF files are blocked
RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "Bot", url: "/document.pdf")     # false

# Temp files are blocked
RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "Bot", url: "/temp/file")       # false

# Exception to temp rule
RobotstxtRb.allowed?(robots_txt: robots_txt, user_agent: "Bot", url: "/temp/public")     # true
```

### Validation

```ruby
# Valid robots.txt
RobotstxtRb.valid?(robots_txt: "User-agent: *\nDisallow: /admin")  # true

# Invalid robots.txt
RobotstxtRb.valid?(robots_txt: "Invalid-directive: value")         # false

# Empty robots.txt is valid
RobotstxtRb.valid?(robots_txt: "")                                 # true
```

## Development

### Setup

1. Clone the repository:
```bash
git clone https://github.com/jacksontrieu/robotstxt-rb.git
cd robotstxt-rb
```

2. Install dependencies:
```bash
bundle install
```

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation
```

### Building the Gem

```bash
gem build robotstxt-rb.gemspec
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details on how to get started.

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Security

Please see our [Security Policy](SECURITY.md) for information on reporting security vulnerabilities.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Related Resources

- [Google's robots.txt specification](https://developers.google.com/search/docs/crawling-indexing/robots/intro)
- [RFC 9309 - Robots Exclusion Protocol](https://tools.ietf.org/html/rfc9309)
- [RubyGems.org page](https://rubygems.org/gems/robotstxt-rb)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.