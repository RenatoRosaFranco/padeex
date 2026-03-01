# frozen_string_literal: true

# Generates placehold.co image URLs with configurable dimensions and text.
#
# @example
#   PlaceholderImage.url(text: "Blog Post")
#   PlaceholderImage.url(width: 1200, height: 600, text: "Custom")
module PlaceholderImage
  BASE_URL = "https://placehold.co"
  DEFAULT_WIDTH = 800
  DEFAULT_HEIGHT = 400
  DEFAULT_BG = "0f1022"
  DEFAULT_FG = "4ade80"
  DEFAULT_TEXT = "PADEX"

  # @param width [Integer] image width in pixels
  # @param height [Integer] image height in pixels
  # @param text [String] text to display on placeholder
  # @param bg [String] background color (hex without #)
  # @param fg [String] text color (hex without #)
  # @return [String] placehold.co URL
  def self.url(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT, text: DEFAULT_TEXT, bg: DEFAULT_BG, fg: DEFAULT_FG)
    encoded_text = ERB::Util.url_encode(text)
    "#{BASE_URL}/#{width}x#{height}/#{bg}/#{fg}?text=#{encoded_text}"
  end
end
