# frozen_string_literal: true

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Scopes
  scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current) }
  scope :recent, -> { order(published_at: :desc) }

  # Validations
  validates :title, presence: true
  validates :content, presence: true

  COVER_PLACEHOLDER = "https://placehold.co/800x400/0f1022/4ade80?text=PADEX"

  # @return [Boolean] true se o post tem data de publicação e já foi publicada
  def published?
    published_at.present? && published_at <= Time.current
  end

  def cover_url
    cover.presence || COVER_PLACEHOLDER
  end

  def author_initials
    author.split.first(2).map { |w| w[0].upcase }.join
  end
end
