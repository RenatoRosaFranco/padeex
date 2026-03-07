# frozen_string_literal: true

class Notification < ApplicationRecord
  # Associations
  belongs_to :tenant
  belongs_to :user

  # Scopes
  scope :unread,  -> { where(read_at: nil) }
  scope :recent,  -> { order(created_at: :desc) }

  # Constants
  ICON_COLORS = %w[purple green amber red blue].freeze

  # @return [Boolean] true if the notification is unread
  def unread?
    read_at.nil?
  end
end
