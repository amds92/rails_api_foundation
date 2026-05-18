# frozen_string_literal: true

require "active_support"
require "active_support/concern"
require "rails_api_foundation/version"
require "rails_api_foundation/configuration"
require "rails_api_foundation/concerns/api_response_helpers"
require "rails_api_foundation/concerns/error_handling"
require "rails_api_foundation/service_object"

if defined?(Rails)
  require "rails_api_foundation/engine"
end

module RailsApiFoundation
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
