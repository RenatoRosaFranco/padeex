# frozen_string_literal: true

module Feed
  class PostComponent < ApplicationComponent
    def initialize(post:, current_user:)
      @post         = post
      @current_user = current_user
    end

    private

    attr_reader :post, :current_user

    # @return [Boolean] whether the post is liked by the current user
    def liked?
      post.liked
    end

    # @return [Boolean] whether the post has an image
    def has_image?
      post.image_url.present?
    end

    # @return [String] "heart-fill" if liked, "heart" otherwise
    def heart_icon
      liked? ? "heart-fill" : "heart"
    end
  end
end
