# frozen_string_literal: true

module Feed
  # Collection of CSS gradients for story rings in the feed.
  module Gradients
    # List of linear gradients (160deg) in CSS format.
    # Used to style the ring around avatars in stories.
    #
    # @return [Array<String>]
    GRADIENTS = [
      "linear-gradient(160deg, #3628c5 0%, #4ade80 100%)",
      "linear-gradient(160deg, #3a1c71 0%, #d76d77 50%, #ffaf7b 100%)",
      "linear-gradient(160deg, #0575e6 0%, #021b79 100%)",
      "linear-gradient(160deg, #f7971e 0%, #ffd200 100%)",
      "linear-gradient(160deg, #11998e 0%, #38ef7d 100%)",
      "linear-gradient(160deg, #ee0979 0%, #ff6a00 100%)",
      "linear-gradient(160deg, #8360c3 0%, #2ebf91 100%)",
      "linear-gradient(160deg, #c94b4b 0%, #4b134f 100%)",
      "linear-gradient(160deg, #134e5e 0%, #71b280 100%)",
      "linear-gradient(160deg, #0f2027 0%, #203a43 50%, #2c5364 100%)",
      "linear-gradient(160deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%)",
      "linear-gradient(160deg, #fc4a1a 0%, #f7b733 100%)",
    ].freeze
  end
end
