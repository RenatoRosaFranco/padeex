# frozen_string_literal: true

# Generates placehold.co image URLs with configurable dimensions and text.
#
# @example
#   PlaceholderImage.url(text: "Blog Post")
#   PlaceholderImage.url(width: 1200, height: 600, text: "Custom")
module PlaceholderImage
  # @param width [Integer] image width in pixels
  # @param height [Integer] image height in pixels
  # @param text [String] text to display on placeholder
  # @param bg [String] background color (hex without #)
  # @param fg [String] text color (hex without #)
  # @return [String] placehold.co URL
  def self.url(width: 800, height: 400, text: "PADEX", bg: "0f1022", fg: "4ade80")
    encoded_text = ERB::Util.url_encode(text)
    "https://placehold.co/#{width}x#{height}/#{bg}/#{fg}?text=#{encoded_text}"
  end
end
