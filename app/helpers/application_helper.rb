# frozen_string_literal: true

module ApplicationHelper
  # @param width [Integer] placeholder width (default 800)
  # @param height [Integer] placeholder height (default 400)
  # @param text [String] placeholder text (default "PADEX")
  # @return [String] placehold.co URL
  def placeholder_image_url(width: 800, height: 400, text: "PADEX")
    PlaceholderImage.url(width: width, height: height, text: text)
  end

  def google_maps_api_key
    ENV["GOOGLE_MAPS_API_KEY"]
  end
end
