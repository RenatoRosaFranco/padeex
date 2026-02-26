# frozen_string_literal: true

module Blog
  class PostsController < ApplicationController
    include Pagy::Method

    layout "landing"

    def index
      @pagy, @posts = pagy(:offset, Post.published.recent, limit: 8)
    end

    def show
      @post = Post.friendly.find(params[:id])
      redirect_to blog_posts_path, alert: "Artigo não encontrado." unless @post.published?
    rescue ActiveRecord::RecordNotFound
      redirect_to blog_posts_path, alert: "Artigo não encontrado."
    end
  end
end
