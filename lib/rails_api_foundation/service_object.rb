module RailsApiFoundation
  class ServiceObject
    Result = Data.define(:success, :payload, :error) do
      def success? = success
      def failure? = !success
    end

    # Call the service. Prefer this over .new(...).call.
    #
    #   result = CreateUser.call(params)
    #   result.success? # => true
    #   result.payload  # => #<User ...>
    #
    def self.call(...)
      new(...).call
    end

    def call
      raise NotImplementedError, "#{self.class}#call must be implemented"
    end

    private

    def success(payload = nil)
      Result.new(success: true, payload: payload, error: nil)
    end

    def failure(error, payload: nil)
      Result.new(success: false, payload: payload, error: error)
    end
  end
end
