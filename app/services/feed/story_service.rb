# frozen_string_literal: true

module Feed
  # Provides feed stories for a given user.
  # Currently returns mock data; replace with real DB query when Story model is ready.
  class StoryService
    Story = Struct.new(
      :id, :author_name, :author_username, :author_initials,
      :author_avatar_url, :image_url, :gradient, :time_label, :seen,
      keyword_init: true
    )

    # TODO: replace mock with real query:
    #   Story.from_followed_users(user)
    #     .where("expires_at > ?", Time.current)
    #     .order(seen_at: :asc, created_at: :desc)
    #     .includes(:author)
    #
    # @param _user [User] current user (unused until real query is implemented)
    # @return [Array<Story>]
    def self.for_user(_user)
      mock_stories
    end

    class << self
      private

      def mock_stories
        raw = JSON.parse(Rails.root.join("data/mocks/feed_stories.json").read)
        raw.each_with_index.map { |h, i| story_from_hash(h, i) }
      end

      def story_from_hash(h, index)
        attrs = h.transform_keys(&:to_sym)
        Story.new(
          id:                attrs[:id],
          author_name:       attrs[:name],
          author_username:   attrs[:username],
          author_initials:   attrs[:initials],
          author_avatar_url: nil,
          image_url:         nil,
          gradient:          Gradients::GRADIENTS[index % Gradients::GRADIENTS.size],
          time_label:        attrs[:time],
          seen:              attrs[:seen]
        )
      end
    end
  end
end
