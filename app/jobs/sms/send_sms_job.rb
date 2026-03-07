# frozen_string_literal: true

module Sms
  class SendSmsJob < ApplicationJob
    queue_as :sms

    retry_on Sms::TwilioClient::Error, wait: :polynomially_longer, attempts: 3

    # @param to   [String] E.164 destination phone number
    # @param body [String] SMS message text
    def perform(to, body)
      Sms::TwilioClient.new.deliver(to: to, body: body)
    end
  end
end
