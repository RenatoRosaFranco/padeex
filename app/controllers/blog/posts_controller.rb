# frozen_string_literal: true

module Blog
  class PostsController < ApplicationController
    include Pagy::Method

    layout "landing"

    def index
      @pagy, @posts = pagy(:offset, Post.published.recent, limit: 8)
    end

    def show
      result = Actions::Find.call(scope: Post.friendly, id: params[:id])
      return redirect_to blog_posts_path, alert: t("errors.post_not_found") if result.failure?

      @post = result.record
      redirect_to blog_posts_path, alert: t("errors.post_not_found") unless @post.published_at? && @post.published_at <= Time.current
    end
  end
end
