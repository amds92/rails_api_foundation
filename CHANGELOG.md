# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-01-15

### Added
- `rails g rails_api_foundation:install` generator
- Structured JSON logging via lograge
- `render_success` / `render_error` / `render_created` / `render_no_content` response helpers
- Centralized error handling (`ActiveRecord::RecordNotFound`, `RecordInvalid`, `ParameterMissing`, `StandardError`)
- Configurable error reporter hook (Sentry, Bugsnag, etc.)
- Health check endpoint at `GET /health` with database and optional Redis checks
- `ApplicationService` base class with `Result` value object
- Optional Sidekiq setup (`--with-sidekiq`)
- Optional Docker templates (`--with-docker`)
- Optional Swagger/rswag setup (`--with-swagger`)
- `RailsApiFoundation.configure` block

[Unreleased]: https://github.com/amds92/rails_api_foundation/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/amds92/rails_api_foundation/releases/tag/v0.1.0
