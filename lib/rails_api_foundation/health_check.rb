# frozen_string_literal: true

module RailsApiFoundation
  class HealthCheck < ServiceObject
    def call
      checks = { database: database_status }
      checks[:redis] = redis_status if RailsApiFoundation.configuration.health_check_redis

      overall = checks.values.all? { |c| c[:status] == "ok" } ? "ok" : "degraded"

      payload = {
        status:    overall,
        version:   Rails.application.config.try(:app_version) || "unknown",
        timestamp: Time.current.iso8601,
        checks:    checks
      }

      overall == "ok" ? success(payload) : failure("degraded", payload: payload)
    end

    private

    def database_status
      ActiveRecord::Base.connection.execute("SELECT 1")
      { status: "ok" }
    rescue => e
      { status: "error", message: e.message }
    end

    def redis_status
      redis = Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
      redis.ping
      { status: "ok" }
    rescue => e
      { status: "error", message: e.message }
    end
  end
end
