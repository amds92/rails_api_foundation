Rails.application.configure do
  config.lograge.enabled   = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.custom_options = lambda do |event|
    options = {
      request_id: event.payload[:request_id],
      host:       event.payload[:host],
      time:       Time.current.iso8601
    }

    # Uncomment to log authenticated user
    # options[:user_id] = event.payload[:user_id]

    options
  end

  # Exclude /health from logs to avoid noise
  config.lograge.ignore_actions = ["HealthController#show"]
end
