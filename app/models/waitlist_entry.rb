# frozen_string_literal: true
  
class WaitlistEntry < ApplicationRecord
  # Valid email regex.
  VALID_EMAIL = URI::MailTo::EMAIL_REGEXP
  
  # Validations
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL, message: "E-mail inválido" },
            uniqueness: { case_sensitive: false, message: "já está na lista" }

  # Callbacks
  before_save { self.email = email.downcase }
end
