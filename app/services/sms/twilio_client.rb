# frozen_string_literal: true

module Sms
  # Thin wrapper around the Twilio REST API.
  #
  # @example
  #   Sms::TwilioClient.new.deliver(to: "+5511999990000", body: "Seu código: 123456")
  class TwilioClient
    # Constants
    Error = Class.new(StandardError)

    def initialize(
      account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
      auth_token:  ENV.fetch("TWILIO_AUTH_TOKEN"),
      from:        ENV.fetch("TWILIO_FROM_NUMBER")
    )
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      @from   = from
    end

    # @param to   [String] E.164 destination phone number
    # @param body [String] SMS message text
    # @return [String] Twilio message SID
    # @raise [Error] on Twilio API failure
    def deliver(to:, body:)
      return log_simulated(to, body) if Rails.env.development?

      message = @client.messages.create(from: @from, to: to, body: body)
      message.sid
    rescue Twilio::REST::TwilioError => e
      SentryFailureCaptureService.call(
        error:         e.message,
        source:        self.class.name,
        extra_context: { to: to },
        exception:     e
      )
      raise Error, "Twilio error: #{e.message}"
    end

    private

    def log_simulated(to, body)
      Rails.logger.info(
        "[Sms::TwilioClient] SIMULATED | to=#{to} from=#{@from} body=#{body.inspect}")
      "simulated"
    end
  end
end
