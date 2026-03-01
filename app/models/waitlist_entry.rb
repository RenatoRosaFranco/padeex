# frozen_string_literal: true

class WaitlistEntry < ApplicationRecord
  include BelongsToTenant

  # Valid email regex.
  VALID_EMAIL = URI::MailTo::EMAIL_REGEXP
  
  # Validations
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL },
            uniqueness: { scope: :tenant_id, case_sensitive: false }

  # Callbacks
  before_save { self.email = email.downcase }
end
