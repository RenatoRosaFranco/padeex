# frozen_string_literal: true

module Feed
  class PostComponent < ApplicationComponent
    def initialize(post:, current_user:)
      @post         = post
      @current_user = current_user
    end

    private

    attr_reader :post, :current_user

    def liked? = post.liked
    def has_image? = post.image_url.present?
    def heart_icon = liked? ? "heart-fill" : "heart"
  end
end
