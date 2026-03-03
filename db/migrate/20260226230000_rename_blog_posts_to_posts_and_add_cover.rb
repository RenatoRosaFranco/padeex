# frozen_string_literal: true

class RenameBlogPostsToPostsAndAddCover < ActiveRecord::Migration[8.1]
  def change
    rename_table :blog_posts, :posts
    add_column :posts, :cover, :string
  end
end
