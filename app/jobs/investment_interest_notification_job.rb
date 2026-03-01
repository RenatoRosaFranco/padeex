# frozen_string_literal: true

# Dispatches new_interest and confirmation emails as separate jobs.
# Both are queued and can run in parallel when multiple workers are available.
#
# @example
#   InvestmentInterestNotificationJob.perform_later(investment_interest)
class InvestmentInterestNotificationJob < ApplicationJob
  queue_as :default

  # Queues both mailer jobs. They run as separate jobs and can execute in parallel.
  # @param interest [InvestmentInterest] the investment interest to notify about
  # @return [void]
  def perform(interest)
    InvestmentInterestMailer.new_interest(interest).deliver_later
    InvestmentInterestMailer.confirmation(interest).deliver_later
  end
end
