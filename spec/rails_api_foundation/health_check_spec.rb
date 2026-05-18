# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsApiFoundation::HealthCheck do
  let(:connection) { instance_double("ActiveRecord::ConnectionAdapters::AbstractAdapter") }

  before do
    ar_base = class_double("ActiveRecord::Base").as_stubbed_const
    allow(ar_base).to receive(:connection).and_return(connection)

    rails = class_double("Rails").as_stubbed_const
    app   = double("app", config: double("config", try: "unknown"))
    allow(rails).to receive(:application).and_return(app)
    allow(rails).to receive(:env).and_return(double(development?: false))
  end

  describe ".call" do
    context "when database is healthy" do
      before { allow(connection).to receive(:execute).with("SELECT 1") }

      it "returns success" do
        expect(described_class.call).to be_success
      end

      it "returns ok status in payload" do
        expect(described_class.call.payload[:status]).to eq("ok")
      end

      it "includes database check" do
        expect(described_class.call.payload.dig(:checks, :database)).to eq({ status: "ok" })
      end

      it "includes timestamp and version" do
        payload = described_class.call.payload
        expect(payload[:timestamp]).not_to be_nil
        expect(payload[:version]).not_to be_nil
      end
    end

    context "when database is down" do
      before do
        allow(connection).to receive(:execute).and_raise(StandardError, "connection refused")
      end

      it "returns failure" do
        expect(described_class.call).to be_failure
      end

      it "returns degraded status in payload" do
        expect(described_class.call.payload[:status]).to eq("degraded")
      end

      it "includes error in database check" do
        result = described_class.call
        expect(result.payload.dig(:checks, :database, :status)).to eq("error")
        expect(result.payload.dig(:checks, :database, :message)).to eq("connection refused")
      end
    end
  end
end
