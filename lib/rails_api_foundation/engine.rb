# frozen_string_literal: true

require "rails"
require "lograge"

module RailsApiFoundation
  class Engine < ::Rails::Engine
    isolate_namespace RailsApiFoundation

    initializer "rails_api_foundation.lograge" do |app|
      next unless RailsApiFoundation.configuration.log_format == :json
      next if app.config.lograge.enabled

      app.config.lograge.enabled       = true
      app.config.lograge.formatter     = Lograge::Formatters::Json.new
      app.config.lograge.base_datetime = true

      app.config.lograge.custom_options = lambda do |event|
        options = {
          request_id: event.payload[:request_id],
          host:       event.payload[:host]
        }

        options[:user_id] = event.payload[:user_id] if event.payload[:user_id]
        options[:params]  = event.payload[:params]  if RailsApiFoundation.configuration.log_include_params

        options
      end
    end
  end
end
