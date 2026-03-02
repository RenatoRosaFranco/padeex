# frozen_string_literal: true

module Payments
  # Thin HTTP client for the OpenPix REST API built on Faraday.
  #
  # @example
  #   client = Payments::OpenpixClient.new
  #   charge = client.create_charge(correlation_id: "order-42", value: 5000)
  class OpenpixClient
    API_BASE = "https://api.openpix.com.br/api/openpix/v1".freeze

    # Raised when the OpenPix API returns a non-2xx response or is unreachable.
    Error = Class.new(StandardError)

    def initialize(app_id: Openpix::APP_ID)
      @connection = Faraday.new(url: API_BASE) do |f|
        f.request  :json
        f.response :json, content_type: /\bjson\b/
        f.response :raise_error

        f.options.timeout      = 10
        f.options.open_timeout = 5

        f.headers["Authorization"] = app_id
      end
    end

    # Creates a PIX charge via the OpenPix API.
    #
    # @param correlation_id [String]  unique idempotency key
    # @param value          [Integer] amount in cents
    # @param comment        [String]  payment description (optional)
    # @return [Hash] parsed charge object from the API response
    # @raise [Error] on non-2xx response or network failure
    def create_charge(correlation_id:, value:, comment: nil)
      post("/charge", {
        correlationID: correlation_id,
        value:         value,
        comment:       comment
      }.compact)
    end

    private

    # @param path [String] API path relative to API_BASE
    # @param body [Hash]   request payload (serialized to JSON by middleware)
    # @return [Hash] parsed response body
    # @raise [Error] wrapping any Faraday::Error
    def post(path, body)
      @connection.post(path, body).body
    rescue Faraday::Error => e
      raise Error, "OpenPix API error: #{e.message}"
    end
  end
end
