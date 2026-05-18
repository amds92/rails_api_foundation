# frozen_string_literal: true

module RailsApiFoundation
  module Concerns
    module ApiResponseHelpers
      extend ActiveSupport::Concern

      # Renders a successful JSON response.
      #
      #   render_success(@user, status: :created)
      #   render_success(@users, meta: { total: 100 })
      #
      def render_success(data = nil, status: RailsApiFoundation.configuration.success_status, message: nil, meta: nil)
        payload = { success: true }
        payload[:data]    = data    unless data.nil?
        payload[:message] = message if message
        payload[:meta]    = meta    if meta

        render json: payload, status: status
      end

      # Renders an error JSON response.
      #
      #   render_error("Not found", status: :not_found)
      #   render_error("Invalid record", errors: record.errors.full_messages)
      #
      def render_error(message, status: RailsApiFoundation.configuration.error_status, errors: nil, code: nil)
        payload = { success: false, error: message }
        payload[:errors] = errors if errors
        payload[:code]   = code   if code

        render json: payload, status: status
      end

      # Renders a created (201) success response.
      def render_created(data = nil, message: nil)
        render_success(data, status: :created, message: message)
      end

      # Renders a no-content (204) response.
      def render_no_content
        head :no_content
      end
    end
  end
end
