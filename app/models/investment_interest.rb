# frozen_string_literal: true

class InvestmentInterest < ApplicationRecord
  VALID_EMAIL = URI::MailTo::EMAIL_REGEXP

  # Investment ranges
  INVESTMENT_RANGES = [
    "R$ 50 mil - R$ 100 mil",
    "R$ 100 mil - R$ 500 mil",
    "R$ 500 mil - R$ 1 milhão",
    "Acima de R$ 1 milhão"
  ].freeze

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL, message: "E-mail inválido" }
  validates :investment_range, presence: true, inclusion: { in: INVESTMENT_RANGES }

  # Callbacks
  before_save { self.email = email.downcase if email.present? }
end
