class ApplicationService < RailsApiFoundation::ServiceObject
  # Base class for all service objects.
  #
  # Usage:
  #   class CreateUser < ApplicationService
  #     def initialize(params)
  #       @params = params
  #     end
  #
  #     def call
  #       user = User.create!(@params)
  #       success(user)
  #     rescue ActiveRecord::RecordInvalid => e
  #       failure(e.message)
  #     end
  #   end
  #
  #   result = CreateUser.call(params)
  #
  #   if result.success?
  #     render_success(result.payload, status: :created)
  #   else
  #     render_error(result.error)
  #   end
end
