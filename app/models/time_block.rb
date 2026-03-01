# frozen_string_literal: true

class TimeBlock < ApplicationRecord
  include BelongsToTenant

  # Associations
  belongs_to :court

  # Validations
  validates :date, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :reason, presence: true

  validate :ends_after_starts
  validate :date_not_in_past

  # Scopes
  scope :for_date, ->(date) { where(date: date) }

  private

  # Validates that the ends_at time is after the starts_at time.
  # @return [void]
  def ends_after_starts
    return unless starts_at && ends_at
    errors.add(:ends_at, :before_start) if ends_at <= starts_at
  end

  # Validates that the date is not in the past.
  # @return [void]
  def date_not_in_past
    return unless date
    errors.add(:date, :invalid_past) if date < Date.current
  end
end
