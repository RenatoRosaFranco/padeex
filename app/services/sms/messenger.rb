# frozen_string_literal: true

module Sms
  # Single entry point for all SMS dispatching in the application.
  # Enqueues Sms::SendSmsJob so delivery is async and parallelized by Solid Queue.
  #
  # @example
  #   Sms::Messenger.deliver(to: "+5511999990000", body: "Seu código: 123456")
  #   Sms::Messenger.deliver(to: "+5511999990000", body: "...", wait: 5.minutes)
  #   Sms::Messenger.deliver(to: "+5511999990000", body: "...", queue: :critical)
  module Messenger
    # @param to    [String]       E.164 destination phone number
    # @param body  [String]       SMS message text
    # @param wait  [ActiveSupport::Duration, nil] delay before processing (optional)
    # @param queue [Symbol, nil]  override queue name (optional)
    def self.deliver(to:, body:, wait: nil, queue: nil)
      job = Sms::SendSmsJob
      job = job.set(wait: wait)   if wait
      job = job.set(queue: queue) if queue
      job.perform_later(to, body)
    end
  end
end
