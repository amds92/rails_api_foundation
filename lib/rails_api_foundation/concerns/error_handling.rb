# frozen_string_literal: true

module RailsApiFoundation
  module Concerns
    module ErrorHandling
      extend ActiveSupport::Concern

      include ApiResponseHelpers

      included do
        rescue_from ActiveRecord::RecordNotFound,        with: :handle_not_found
        rescue_from ActiveRecord::RecordInvalid,         with: :handle_record_invalid
        rescue_from ActionController::ParameterMissing,  with: :handle_parameter_missing
        rescue_from ActionController::RoutingError,      with: :handle_not_found
        rescue_from StandardError,                       with: :handle_internal_error
      end

      private

      def handle_not_found(exception)
        render_error(exception.message, status: :not_found, code: "not_found")
      end

      def handle_record_invalid(exception)
        render_error(
          "Validation failed",
          status: :unprocessable_entity,
          errors: exception.record.errors.full_messages,
          code: "validation_error"
        )
      end

      def handle_parameter_missing(exception)
        render_error(exception.message, status: :bad_request, code: "bad_request")
      end

      def handle_internal_error(exception)
        RailsApiFoundation.configuration.error_reporter&.call(exception)

        Rails.logger.error("[RailsApiFoundation] #{exception.class}: #{exception.message}")
        Rails.logger.error(exception.backtrace.first(5).join("\n")) if Rails.env.development?

        render_error("Internal server error", status: :internal_server_error, code: "internal_error")
      end
    end
  end
end
