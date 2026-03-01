# frozen_string_literal: true

class Post < ApplicationRecord
  include BelongsToTenant

  # Friendly ID
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Scopes
  scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current) }
  scope :recent, -> { order(published_at: :desc) }

  # Validations
  validates :title, presence: true
  validates :content, presence: true

  # @param width [Integer] placeholder width (default 800)
  # @param height [Integer] placeholder height (default 400)
  # @param text [String] placeholder text (default: post title or "PADEX")
  # @return [String] cover image URL or placeholder when absent
  def cover_url(width: 800, height: 400, text: nil)
    cover.presence || PlaceholderImage.url(width: width, height: height, text: text)
  end

  # @return [String] author initials (first letters of the first two names)
  def author_initials
    author.split.first(2).map { |w| w[0].upcase }.join
  end
end
