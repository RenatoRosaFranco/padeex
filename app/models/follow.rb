# frozen_string_literal: true

class Follow < ApplicationRecord
  # Associations
  belongs_to :tenant
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # Enums
  enum :status, { pending: "pending", accepted: "accepted" }

  # Validations
  validates :follower_id, uniqueness: { scope: :followed_id }
  validate  :cannot_follow_self

  private

  # Validates that the follower cannot follow themselves.
  # @return [void]
  def cannot_follow_self
    errors.add(:base, :cannot_follow_self) if follower_id == followed_id
  end
end
