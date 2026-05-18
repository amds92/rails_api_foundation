require "rails_helper"

RSpec.configure do |config|
  config.swagger_root = Rails.root.join("swagger").to_s

  config.swagger_docs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title:   Rails.application.class.module_parent_name,
        version: "v1",
        description: "API documentation"
      },
      components: {
        securitySchemes: {
          bearer_auth: {
            type:   :http,
            scheme: :bearer
          }
        }
      },
      security: [{ bearer_auth: [] }],
      servers: [
        { url: "https://{host}", variables: { host: { default: "api.example.com" } } },
        { url: "http://localhost:3000", description: "Local development" }
      ]
    }
  }

  config.swagger_format = :yaml
end
