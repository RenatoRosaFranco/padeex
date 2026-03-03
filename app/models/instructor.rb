# frozen_string_literal: true

class Instructor < ApplicationRecord
  include BelongsToTenant

  # Associations
  belongs_to :club, class_name: "User", foreign_key: :club_id
  belongs_to :user, optional: true

  # Attachments
  has_one_attached :photo

  # Validations
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :internal_code, uniqueness: { scope: :club_id }, allow_blank: true

  # Callbacks
  before_validation :normalize_internal_code
  before_save :link_platform_account

  private

  def normalize_internal_code
    self.internal_code = nil if internal_code.blank?
  end

  # Links instructor to platform user by matching email within the same tenant.
  # @return [void]
  def link_platform_account
    return if email.blank?
    self.user_id = User.where(tenant_id: tenant_id, email: email).pick(:id)
  end
end
