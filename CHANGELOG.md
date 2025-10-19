# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-19

### Added
- Initial release of robotstxt-rb gem
- Native FFI bindings to Google's official C++ robots.txt parser
- `RobotstxtRb.allowed?` method for checking URL access permissions
- `RobotstxtRb.valid?` method for validating robots.txt content
- Support for macOS (ARM64 and x86_64) and Linux (ARM64 and x86_64) platforms
- Comprehensive test suite with 100+ test cases covering:
  - Basic robots.txt parsing and URL checking
  - User agent specific rules and case-insensitive matching
  - Wildcard pattern matching (e.g., `*.pdf$`, `/temp*`)
  - Multiple disallow/allow rules with precedence handling
  - Edge cases including malformed URLs, unicode characters, and special characters
  - RFC 9309 compliance for case sensitivity behavior
  - Error handling for invalid inputs
- Apache 2.0 license
- Complete documentation and examples

### Technical Details
- Built with Ruby FFI for native performance
- Pre-compiled native libraries for supported platforms
- Ruby 2.0+ compatibility
- FFI dependency (~> 1.16)
- RSpec test framework for development

[Unreleased]: https://github.com/jacksontrieu/robotstxt-rb/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/jacksontrieu/robotstxt-rb/releases/tag/v1.0.0
