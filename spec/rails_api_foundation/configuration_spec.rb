# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsApiFoundation::Configuration do
  subject(:config) { described_class.new }

  describe "defaults" do
    it { expect(config.log_format).to eq(:json) }
    it { expect(config.log_include_params).to be(true) }
    it { expect(config.success_status).to eq(:ok) }
    it { expect(config.error_status).to eq(:unprocessable_entity) }
    it { expect(config.health_check_redis).to be(false) }
    it { expect(config.error_reporter).to be_nil }
  end

  describe "configure block" do
    before do
      RailsApiFoundation.configure do |c|
        c.log_format   = :text
        c.error_status = :bad_request
      end
    end

    it "applies overrides" do
      expect(RailsApiFoundation.configuration.log_format).to eq(:text)
      expect(RailsApiFoundation.configuration.error_status).to eq(:bad_request)
    end

    it "keeps unset defaults" do
      expect(RailsApiFoundation.configuration.success_status).to eq(:ok)
    end
  end

  describe ".reset_configuration!" do
    before { RailsApiFoundation.configure { |c| c.log_format = :text } }

    it "restores defaults" do
      RailsApiFoundation.reset_configuration!
      expect(RailsApiFoundation.configuration.log_format).to eq(:json)
    end
  end
end
