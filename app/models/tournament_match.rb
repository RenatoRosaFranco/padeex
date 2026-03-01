# frozen_string_literal: true

class TournamentMatch < ApplicationRecord
  include BelongsToTenant

  # Associations
  belongs_to :tournament_category
  belongs_to :tournament_group,    optional: true
  belongs_to :court,               optional: true
  belongs_to :home_registration,   class_name: "TournamentRegistration"
  belongs_to :away_registration,   class_name: "TournamentRegistration"

  # Enums
  enum :status, {
    scheduled:   "scheduled",
    in_progress: "in_progress",
    finished:    "finished",
    cancelled:   "cancelled"
  }

  # Validations
  validates :home_registration, presence: true
  validates :away_registration, presence: true
  validate  :different_registrations

  # Scopes
  default_scope { order(:position, :scheduled_at) }

  # @return [String] human-readable status label
  def status_label
    self.class.status_labels.fetch(status.to_s, status.to_s.humanize)
  end

  # @return [Hash] status => label mapping from app config
  def self.status_labels
    AppConfigService.fetch(:tournament_match_status_labels, default: {}).with_indifferent_access
  end

  # @return [String] human-readable result label
  def result_label
    return nil unless finished? && home_score.present? && away_score.present?
    "#{home_score} × #{away_score}"
  end

  # @return [Symbol, nil] winner symbol (:home, :away, :draw) or nil if undetermined
  def winner
    TournamentMatches::DetermineWinner.call(match: self).winner
  end

  private

  # Validates that home and away registrations are different.
  # @return [void]
  def different_registrations
    return unless home_registration_id && away_registration_id
    errors.add(:base, :different_pairs) if home_registration_id == away_registration_id
  end
end
