RailsApiFoundation.configure do |config|
  # Logging format: :json (default) or :text
  config.log_format = :json

  # Include request params in structured logs
  config.log_include_params = true

  # Params to filter from logs (added on top of Rails filter_parameters)
  config.log_filter_params = %w[password password_confirmation token secret credit_card]

  # Default HTTP status for render_success
  config.success_status = :ok

  # Default HTTP status for render_error
  config.error_status = :unprocessable_entity

  # Include Redis in /health check (requires redis gem)
  config.health_check_redis = false

  # Optional error reporter (e.g. Sentry, Bugsnag)
  # config.error_reporter = ->(exception) { Sentry.capture_exception(exception) }
end
