# frozen_string_literal: true

class UserIdentity < ApplicationRecord
  # Associations
  belongs_to :tenant
  belongs_to :user

  # Validations
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: [:tenant_id, :provider] }
end
