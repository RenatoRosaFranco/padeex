# frozen_string_literal: true

class TournamentCategory < ApplicationRecord
  include BelongsToTenant

  # Associations
  has_many :registrations, class_name: "TournamentRegistration", dependent: :destroy
  has_many :groups,        class_name: "TournamentGroup",        dependent: :destroy
  has_many :matches,       class_name: "TournamentMatch",        dependent: :destroy

  belongs_to :tournament

  # Enums
  enum :gender, { masculine: "masculine", feminine: "feminine", mixed: "mixed" }

  # Validations
  validates :name,       presence: true
  validates :tournament, presence: true

  # Scopes
  default_scope { order(:position) }

  # @return [String] human-readable gender label
  def gender_label
    I18n.t("tournament_category.gender_labels.#{gender}", default: gender.to_s.humanize)
  end

  # @return [Boolean] true when registration_deadline is nil or in the future
  def registration_open?
    registration_deadline.nil? || registration_deadline >= Date.current
  end

  # @return [Integer] count of confirmed registrations
  def confirmed_count
    registrations.confirmed.count
  end

  # @return [Boolean] true when max_pairs is set and confirmed_count has reached it
  def full?
    max_pairs.present? && confirmed_count >= max_pairs
  end
end
