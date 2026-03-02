# frozen_string_literal: true

class TournamentRegistration < ApplicationRecord
  include BelongsToTenant

  # Associations
  belongs_to :tournament_category
  belongs_to :user
  has_one :order, as: :orderable, dependent: :destroy
  has_one :group_membership, class_name: "TournamentGroupMembership", dependent: :destroy
  has_one :group, through: :group_membership, class_name: "TournamentGroup"

  # Enums
  enum :status, {
    pending:    "pending",
    confirmed:  "confirmed",
    waitlisted: "waitlisted"
  }

  # Validations
  validates :tournament_category, presence: true
  validates :user,                presence: true
  validates :user_id, uniqueness: {
    scope:   :tournament_category_id,
    message: :already_registered
  }

  # @return [String] human-readable status label
  def status_label
    I18n.t("tournament_registration.status_labels.#{status}")
  end

  # @return [String] display name combining user name and optional partner name (e.g. "João / Maria")
  def display_name
    parts = [user.name]
    parts << partner_name if partner_name.present?
    parts.join(" / ")
  end
end
