class HealthController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :authenticate_request!, raise: false

  def show
    result = RailsApiFoundation::HealthCheck.call
    render json: result.payload, status: result.success? ? :ok : :service_unavailable
  end
end
