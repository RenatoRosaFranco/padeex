# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user

  scope :unread,  -> { where(read_at: nil) }
  scope :recent,  -> { order(created_at: :desc) }

  ICON_COLORS = %w[purple green amber red blue].freeze

  def unread?
    read_at.nil?
  end
end
