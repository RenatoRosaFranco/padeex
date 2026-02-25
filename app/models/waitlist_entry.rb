class WaitlistEntry < ApplicationRecord
  VALID_EMAIL = URI::MailTo::EMAIL_REGEXP

  validates :email,
    presence: true,
    format: { with: VALID_EMAIL, message: "inválido" },
    uniqueness: { case_sensitive: false, message: "já está na lista" }

  before_save { self.email = email.downcase }
end
