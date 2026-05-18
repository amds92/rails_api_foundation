# Rails API Foundation

> Stop configuring. Start building.

[![Gem Version](https://badge.fury.io/rb/rails_api_foundation.svg)](https://badge.fury.io/rb/rails_api_foundation)
[![CI](https://github.com/amds92/rails_api_foundation/actions/workflows/ci.yml/badge.svg)](https://github.com/amds92/rails_api_foundation/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**Rails API Foundation** is a production-ready foundation for Ruby on Rails API applications.

It automates the repetitive infrastructure setup that every API project needs:
structured logging, centralized error handling, standardized responses, health checks, and service objects.

---

## Why?

Every Rails API project starts the same way:

- Copy-paste the same logging setup
- Rewrite the same `render json: { error: ... }` response helpers
- Configure the same error rescues in `ApplicationController`
- Build the same health check endpoint
- Define the same `ApplicationService` base class

**Rails API Foundation eliminates that work in a single command.**

---

## Quick Start

### 1. Add to your Gemfile

```ruby
gem "rails_api_foundation"
```

```sh
bundle install
```

### 2. Run the installer

```sh
rails g rails_api_foundation:install
```

### 3. Include in ApplicationController

```ruby
class ApplicationController < ActionController::API
  include ApiResponseHelpers
  include ErrorHandling
end
```

**That's it.** Your API now has structured logging, standardized responses, and centralized error handling.

---

## Features

### Standardized API Responses

**Before:**
```ruby
render json: { error: "Something failed" }, status: 500
render json: { data: @user }, status: 200
```

**After:**
```ruby
render_error("Something failed")
render_success(@user)
```

All response helpers:

| Helper | Status | Description |
|--------|--------|-------------|
| `render_success(data)` | 200 | Success with optional data |
| `render_success(data, status: :created)` | 201 | Custom success status |
| `render_success(data, meta: { total: 100 })` | 200 | With pagination metadata |
| `render_created(data)` | 201 | Shorthand for created |
| `render_error(message)` | 422 | Error with message |
| `render_error(message, status: :not_found)` | 404 | Custom error status |
| `render_error(message, errors: [...])` | 422 | With validation errors |
| `render_no_content` | 204 | No content response |

**Response format:**

```json
// Success
{ "success": true, "data": { "id": 1, "name": "André" } }

// Success with meta
{ "success": true, "data": [...], "meta": { "total": 100, "page": 1 } }

// Error
{ "success": false, "error": "Validation failed", "errors": ["Name can't be blank"] }
```

---

### Centralized Error Handling

Automatic rescue for common exceptions — no more duplicate rescue blocks:

| Exception | HTTP Status | Code |
|-----------|-------------|------|
| `ActiveRecord::RecordNotFound` | 404 | `not_found` |
| `ActiveRecord::RecordInvalid` | 422 | `validation_error` |
| `ActionController::ParameterMissing` | 400 | `bad_request` |
| `StandardError` | 500 | `internal_error` |

Custom error reporter (Sentry, Bugsnag, etc.):

```ruby
# config/initializers/rails_api_foundation.rb
RailsApiFoundation.configure do |config|
  config.error_reporter = ->(exception) { Sentry.capture_exception(exception) }
end
```

---

### Structured JSON Logging

Every request logs structured JSON via [lograge](https://github.com/roidrage/lograge):

```json
{
  "method": "POST",
  "path": "/api/v1/users",
  "status": 201,
  "duration": 23.4,
  "request_id": "abc-123",
  "host": "api.example.com",
  "time": "2025-01-15T10:30:00Z"
}
```

Add user context in your `ApplicationController`:

```ruby
def append_info_to_payload(payload)
  super
  payload[:user_id] = current_user&.id
end
```

---

### Health Check Endpoint

```
GET /health
```

```json
{
  "status": "ok",
  "version": "1.0.0",
  "timestamp": "2025-01-15T10:30:00Z",
  "checks": {
    "database": { "status": "ok" }
  }
}
```

With Redis check enabled (`config.health_check_redis = true`):

```json
{
  "status": "ok",
  "checks": {
    "database": { "status": "ok" },
    "redis":    { "status": "ok" }
  }
}
```

Returns `503 Service Unavailable` if any check fails — ready for load balancers and Kubernetes probes.

---

### Service Object Pattern

A clean, consistent pattern for business logic:

```ruby
# app/services/create_user.rb
class CreateUser < ApplicationService
  def initialize(params)
    @params = params
  end

  def call
    user = User.create!(@params)
    success(user)
  rescue ActiveRecord::RecordInvalid => e
    failure(e.message)
  end
end
```

Usage in controllers:

```ruby
def create
  result = CreateUser.call(user_params)

  if result.success?
    render_created(result.payload)
  else
    render_error(result.error)
  end
end
```

The result object:

```ruby
result.success?  # => true / false
result.failure?  # => false / true
result.payload   # => the returned value (on success)
result.error     # => the error message (on failure)
```

---

## Optional Features

### Sidekiq

```sh
rails g rails_api_foundation:install --with-sidekiq
```

Generates:
- `config/initializers/sidekiq.rb` — Redis connection
- `config/sidekiq.yml` — queues and concurrency
- Mounts Sidekiq Web UI at `/sidekiq` in development

### Docker

```sh
rails g rails_api_foundation:install --with-docker
```

Generates:
- `Dockerfile` — multi-stage production build
- `docker-compose.yml` — app + PostgreSQL + Redis
- `.dockerignore`

### Swagger / OpenAPI

```sh
rails g rails_api_foundation:install --with-swagger
```

Generates rswag setup with sensible defaults. Run:

```sh
rails rswag:specs:swaggerize
```

to generate your `swagger/v1/swagger.yaml` and browse at `/api-docs`.

---

## Configuration

Full configuration reference (`config/initializers/rails_api_foundation.rb`):

```ruby
RailsApiFoundation.configure do |config|
  # Logging
  config.log_format         = :json           # :json | :text
  config.log_include_params = true            # log request params
  config.log_filter_params  = %w[password token]

  # Responses
  config.success_status = :ok                 # default success HTTP status
  config.error_status   = :unprocessable_entity

  # Health check
  config.health_check_redis = false           # include Redis in /health

  # Error reporting (Sentry, Bugsnag, etc.)
  config.error_reporter = ->(e) { Sentry.capture_exception(e) }
end
```

---

## Requirements

- Ruby 3.2+
- Rails 7.0+
- PostgreSQL (recommended)

---

## Installation (all options)

```sh
# Core only (logging + responses + health + service objects)
rails g rails_api_foundation:install

# With all optional features
rails g rails_api_foundation:install --with-sidekiq --with-docker --with-swagger
```

---

## Roadmap

**v0.1** (current)
- [x] Structured JSON logging
- [x] Standardized API response helpers
- [x] Centralized error handling
- [x] Health check endpoint
- [x] Service object base class
- [x] Optional Sidekiq setup
- [x] Optional Docker templates
- [x] Optional Swagger/rswag setup

**v0.2**
- [ ] Request metrics middleware
- [ ] Rate limiting helpers
- [ ] API versioning conventions
- [ ] Pagination helpers (pagy integration)

**v0.3**
- [ ] Authentication scaffold (JWT / Devise Token Auth)
- [ ] Audit log concern
- [ ] Background job base class

---

## Development

```sh
git clone https://github.com/amds92/rails_api_foundation
cd rails_api_foundation
bundle install
bundle exec rspec
```

---

## Contributing

Bug reports and pull requests are welcome at [github.com/amds92/rails_api_foundation](https://github.com/amds92/rails_api_foundation).

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Add tests
4. Open a pull request

---

## License

MIT — see [LICENSE](LICENSE).

---

Built with care by [André Silva](https://github.com/amds92).
