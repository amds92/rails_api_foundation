require_relative "lib/rails_api_foundation/version"

Gem::Specification.new do |spec|
  spec.name    = "rails_api_foundation"
  spec.version = RailsApiFoundation::VERSION
  spec.authors = ["André Silva"]
  spec.email   = ["veonjr@gmail.com"]

  spec.summary     = "Production-ready foundation for Ruby on Rails APIs"
  spec.description = "Automates and standardizes common backend infrastructure patterns for Rails API applications: structured JSON logging, API response helpers, centralized error handling, health checks, service objects, and more."
  spec.homepage    = "https://github.com/amds92/rails_api_foundation"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  spec.files = Dir[
    "lib/**/*",
    "LICENSE",
    "README.md",
    "CHANGELOG.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "lograge", ">= 0.12"

  spec.add_development_dependency "rspec-rails", ">= 6.0"
  spec.add_development_dependency "rubocop-rails-omakase"
  spec.add_development_dependency "simplecov"
end
