# frozen_string_literal: true

class TournamentGroup < ApplicationRecord
  include BelongsToTenant

  # Associations
  belongs_to :tournament_category
  has_many :memberships,   class_name: "TournamentGroupMembership", dependent: :destroy
  has_many :registrations, through: :memberships,                   class_name: "TournamentRegistration"
  has_many :matches,       class_name: "TournamentMatch",           dependent: :destroy, foreign_key: :tournament_group_id

  # Validations
  validates :name,               presence: true
  validates :tournament_category, presence: true

  # Scopes
  default_scope { order(:position) }
end
