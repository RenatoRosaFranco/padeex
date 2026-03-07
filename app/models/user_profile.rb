# frozen_string_literal: true

class UserProfile < ApplicationRecord
  # Associations
  belongs_to :tenant
  belongs_to :user

  # Attachments
  has_one_attached :avatar

  # Validations
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-z0-9._]+\z/i },
                       length: { minimum: 3, maximum: 30 }

  validates :birth_date, presence: true
  validates :gender,     presence: true
end
