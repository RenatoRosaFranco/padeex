# frozen_string_literal: true

class InvestmentInterest < ApplicationRecord
  include BelongsToTenant

  # Constants
  VALID_EMAIL = URI::MailTo::EMAIL_REGEXP

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL }
  validates :investment_range, presence: true, inclusion: { in: ->(r) { r.class.investment_ranges } }

  # @return [Array<String>] investment range options from app config
  def self.investment_ranges
    AppConfigService.fetch(:investment_ranges, default: []).freeze
  end

  # Callbacks
  before_save  { self.email = email.downcase if email.present? }
  after_create_commit :notify_team

  private

  # Queues InvestmentInterestNotificationJob to dispatch  emails.
  # @return [void]
  def notify_team
    InvestmentInterestNotificationJob.perform_later(self)
  end
end
