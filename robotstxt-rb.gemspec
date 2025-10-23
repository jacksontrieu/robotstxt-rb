Gem::Specification.new do |spec|
  spec.name          = "robotstxt-rb"
  spec.version       = "1.0.0"
  spec.summary       = "Ruby gem providing native bindings to Google's official C++ robots.txt parser and matcher."
  spec.description   = "Enables fast, standards-compliant robots.txt parsing and URL access checking directly from Ruby."
  spec.license       = "Apache-2.0"
  spec.authors       = ["Jackson Trieu"]
  spec.homepage      = "https://github.com/jacksontrieu/robotstxt-rb"
  spec.files         = Dir["lib/**/*", "LICENSE", "README.md", "src/**/*"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0"

  spec.add_dependency "ffi", "~> 1.16"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.81"
  spec.add_development_dependency "rubocop-rspec", "~> 3.7"

  spec.add_development_dependency "simplecov", require: false
end