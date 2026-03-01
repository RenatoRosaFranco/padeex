# frozen_string_literal: true

class Tournament < ApplicationRecord
  include BelongsToTenant

  # Attachments
  has_one_attached :banner
  has_one_attached :edital

  # Associations
  belongs_to :club, class_name: "User", foreign_key: :club_id
  has_many :categories, class_name: "TournamentCategory", dependent: :destroy

  # Enums
  enum :status, {
    draft:       "draft",
    open:        "open",
    in_progress: "in_progress",
    finished:    "finished",
    cancelled:   "cancelled"
  }

  # Validations
  validates :name,      presence: true
  validates :starts_on, presence: true
  validates :ends_on,   presence: true
  validates :status,    presence: true

  validate :ends_after_starts

  # @return [String] human-readable status label.
  def status_label
    label_for(:status)
  end

  # @return [String] human-readable format label.
  def format_label
    label_for(:format)
  end

  # @param field [Symbol] attribute name (e.g. :status, :format)
  # @return [Hash] value => label mapping from app config
  def self.field_labels(field)
    fetch_config(:"tournament_#{field}_labels").with_indifferent_access
  end

  # @param key [Symbol] config key
  # @param default [Object] fallback when key missing
  # @return [Object] config value
  def self.fetch_config(key, default: {})
    AppConfigService.fetch(key, default: default)
  end

  # @return [Hash] status => label mapping from app config
  def self.status_labels
    field_labels(:status)
  end

  # @return [Hash] format => label mapping from app config
  def self.format_labels
    field_labels(:format)
  end

  private

  # @param field [Symbol] attribute name (e.g. :status, :format)
  # @return [String] human-readable label for the attribute value
  def label_for(field)
    value = send(field).to_s.presence || ""
    self.class.field_labels(field).fetch(value, value.humanize)
  end

  # Validates that ends_on is after starts_on.
  # @return [void]
  def ends_after_starts
    return unless starts_on && ends_on
    errors.add(:ends_on, :after_start) if ends_on < starts_on
  end
end
