require "rails/generators"

module RailsApiFoundation
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Installs RailsApiFoundation into your Rails API application."

      class_option :with_sidekiq, type: :boolean, default: false,
                   desc: "Add Sidekiq configuration"
      class_option :with_docker, type: :boolean, default: false,
                   desc: "Add Docker templates (Dockerfile + docker-compose.yml)"
      class_option :with_swagger, type: :boolean, default: false,
                   desc: "Add rswag/Swagger setup"

      def create_initializer
        template "initializers/rails_api_foundation.rb",
                 "config/initializers/rails_api_foundation.rb"
      end

      def create_lograge_initializer
        template "initializers/lograge.rb",
                 "config/initializers/lograge.rb"
      end

      def create_application_service
        template "application_service.rb",
                 "app/services/application_service.rb"
      end

      def create_api_concerns
        template "concerns/api_response_helpers.rb",
                 "app/controllers/concerns/api_response_helpers.rb"
        template "concerns/error_handling.rb",
                 "app/controllers/concerns/error_handling.rb"
      end

      def create_health_controller
        template "health/health_controller.rb",
                 "app/controllers/health_controller.rb"
        route 'get "/health", to: "health#show"'
        say_status :route, "GET /health => health#show", :green
      end

      def setup_sidekiq
        return unless options[:with_sidekiq]

        template "initializers/sidekiq.rb", "config/initializers/sidekiq.rb"
        template "sidekiq/sidekiq.yml", "config/sidekiq.yml"
        route 'mount Sidekiq::Web => "/sidekiq" if Rails.env.development?'
        say_status :sidekiq, "Sidekiq configured", :green
        say "  Add `gem 'sidekiq'` to your Gemfile if you haven't already.", :yellow
      end

      def setup_docker
        return unless options[:with_docker]

        template "docker/Dockerfile", "Dockerfile"
        template "docker/docker-compose.yml", "docker-compose.yml"
        template "docker/.dockerignore", ".dockerignore"
        say_status :docker, "Docker templates created", :green
      end

      def setup_swagger
        return unless options[:with_swagger]

        template "swagger/rswag_api.rb",     "config/initializers/rswag_api.rb"
        template "swagger/rswag_ui.rb",      "config/initializers/rswag_ui.rb"
        template "swagger/swagger_helper.rb", "spec/swagger_helper.rb"
        route 'mount Rswag::Ui::Engine => "/api-docs"'
        route 'mount Rswag::Api::Engine => "/api-docs"'
        say_status :swagger, "rswag setup complete — run `rails rswag:specs:swaggerize` to generate docs", :green
        say "  Add `gem 'rswag'` to your Gemfile if you haven't already.", :yellow
      end

      def display_instructions
        say "\n"
        say "=" * 60, :green
        say "  RailsApiFoundation installed successfully!", :bold
        say "=" * 60, :green
        say "\n"
        say "Next steps:", :bold
        say "  1. Review config/initializers/rails_api_foundation.rb"
        say "  2. Include concerns in app/controllers/application_controller.rb:"
        say "\n"
        say "       include ApiResponseHelpers", :cyan
        say "       include ErrorHandling", :cyan
        say "\n"
        say "  3. Use ApplicationService for business logic:"
        say "\n"
        say "       class CreateUser < ApplicationService", :cyan
        say "         def call", :cyan
        say "           ...", :cyan
        say "         end", :cyan
        say "       end", :cyan
        say "\n"
        say "  4. Health check available at GET /health"
        say "\n"
        say "See https://github.com/amds92/rails_api_foundation for full docs."
        say "\n"
      end
    end
  end
end
