# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsApiFoundation::HealthCheck do
  describe ".call" do
    context "when database is healthy" do
      before do
        allow(ActiveRecord::Base.connection).to receive(:execute).with("SELECT 1")
      end

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
        allow(ActiveRecord::Base.connection).to receive(:execute)
          .and_raise(PG::ConnectionBad, "connection refused")
      end

      it "returns failure" do
        expect(described_class.call).to be_failure
      end

      it "returns degraded status in payload" do
        expect(described_class.call.payload[:status]).to eq("degraded")
      end

      it "includes error message in database check" do
        result = described_class.call
        expect(result.payload.dig(:checks, :database, :status)).to eq("error")
      end
    end
  end
end
