module RailsApiFoundation
  class Configuration
    # Logging
    attr_accessor :log_format          # :json | :text
    attr_accessor :log_include_params  # include request params in logs
    attr_accessor :log_filter_params   # params to filter (e.g. passwords)

    # API Responses
    attr_accessor :success_status      # default HTTP status for render_success
    attr_accessor :error_status        # default HTTP status for render_error

    # Health check
    attr_accessor :health_check_redis  # include Redis check in /health

    # Error reporting — assign a callable, e.g. Sentry or Bugsnag notifier
    #   RailsApiFoundation.configure { |c| c.error_reporter = ->(e) { Sentry.capture_exception(e) } }
    attr_accessor :error_reporter

    def initialize
      @log_format         = :json
      @log_include_params = true
      @log_filter_params  = %w[password password_confirmation token secret]

      @success_status     = :ok
      @error_status       = :unprocessable_entity

      @health_check_redis = false
      @error_reporter     = nil
    end
  end
end
