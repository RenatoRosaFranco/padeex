# frozen_string_literal: true

class Court < ApplicationRecord
  include BelongsToTenant

  # Constants
  TYPES = %w[indoor outdoor panoramic].freeze

  # Enums
  enum :status, { active: "active", inactive: "inactive" }

  # Associations
  has_many :bookings, dependent: :destroy
  has_many :time_blocks, dependent: :destroy

  belongs_to :club, class_name: "User", foreign_key: :club_id, optional: true

  # Validations
  validates :name, presence: true, uniqueness: { scope: :club_id, message: :taken_in_club }
  validates :court_type, presence: true, inclusion: { in: TYPES }
  validates :status, presence: true

  # Scopes
  scope :available, -> { where(status: :active) }
end
