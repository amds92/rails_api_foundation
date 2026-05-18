# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsApiFoundation::ServiceObject do
  let(:success_service) do
    Class.new(described_class) do
      def call = success("hello")
    end
  end

  let(:failure_service) do
    Class.new(described_class) do
      def call = failure("something went wrong")
    end
  end

  let(:unimplemented_service) do
    Class.new(described_class)
  end

  describe ".call" do
    it "delegates to #call on a new instance" do
      result = success_service.call
      expect(result).to be_a(RailsApiFoundation::ServiceObject::Result)
    end
  end

  describe "successful result" do
    subject(:result) { success_service.call }

    it { is_expected.to be_success }
    it { is_expected.not_to be_failure }

    it "carries the payload" do
      expect(result.payload).to eq("hello")
    end

    it "has nil error" do
      expect(result.error).to be_nil
    end
  end

  describe "failure result" do
    subject(:result) { failure_service.call }

    it { is_expected.to be_failure }
    it { is_expected.not_to be_success }

    it "carries the error message" do
      expect(result.error).to eq("something went wrong")
    end

    it "has nil payload" do
      expect(result.payload).to be_nil
    end
  end

  describe "unimplemented #call" do
    it "raises NotImplementedError" do
      expect { unimplemented_service.call }.to raise_error(NotImplementedError)
    end
  end
end
