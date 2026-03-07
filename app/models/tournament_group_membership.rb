# frozen_string_literal: true

class TournamentGroupMembership < ApplicationRecord
  # Associations
  belongs_to :tenant
  belongs_to :tournament_group
  belongs_to :tournament_registration

  # Validations
  validates :tournament_group_id, uniqueness: { scope: :tournament_registration_id }
end
