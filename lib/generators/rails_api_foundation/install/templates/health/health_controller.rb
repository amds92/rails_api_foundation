class HealthController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :authenticate_request!, raise: false

  def show
    render json: health_payload, status: http_status
  end

  private

  def health_payload
    checks = {
      status:    overall_status,
      version:   Rails.application.config.try(:app_version) || "unknown",
      timestamp: Time.current.iso8601,
      checks:    {
        database: database_status
      }
    }

    checks[:checks][:redis] = redis_status if RailsApiFoundation.configuration.health_check_redis

    checks
  end

  def overall_status
    return "degraded" if database_status[:status] == "error"
    return "degraded" if RailsApiFoundation.configuration.health_check_redis && redis_status[:status] == "error"

    "ok"
  end

  def http_status
    overall_status == "ok" ? :ok : :service_unavailable
  end

  def database_status
    @database_status ||= begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      { status: "ok" }
    rescue => e
      { status: "error", message: e.message }
    end
  end

  def redis_status
    @redis_status ||= begin
      redis = Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
      redis.ping
      { status: "ok" }
    rescue => e
      { status: "error", message: e.message }
    end
  end
end
