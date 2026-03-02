# frozen_string_literal: true

module Feed
  # Provides feed posts for a given user.
  # Currently returns mock data; replace with real DB query when Post model is ready.
  class PostService
    Post = Struct.new(
      :id, :author_name, :author_username, :author_initials,
      :author_official, :author_avatar_url,
      :body, :image_url, :likes_count, :comments_count,
      :created_at, :liked,
      keyword_init: true
    )

    # TODO: replace mock with real query:
    #   Post.from_followed_users(user)
    #     .or(Post.from_official_accounts)
    #     .order(created_at: :desc)
    #     .includes(:author)
    #     .limit(20)
    #
    # @param _user [User] current user (unused until real query is implemented)
    # @return [Array<Post>]
    def self.for_user(_user)
      mock_posts
    end

    class << self
      private

      def mock_posts
        raw = JSON.parse(Rails.root.join("data/mocks/feed_posts.json").read)
        raw.map { |h| post_from_hash(h) }
      end

      def post_from_hash(h)
        attrs = h.transform_keys(&:to_sym)
        attrs[:created_at] = parse_relative_time(attrs[:created_at])
        Post.new(**attrs)
      end

      def parse_relative_time(str)
        return str if str.is_a?(Time) || str.is_a?(ActiveSupport::TimeWithZone)
        return Time.current unless str.is_a?(String)

        case str
        when /\A(\d+)_hours?_ago\z/   then Regexp.last_match(1).to_i.hours.ago
        when /\A(\d+)_days?_ago\z/    then Regexp.last_match(1).to_i.days.ago
        when /\A(\d+)_minutes?_ago\z/ then Regexp.last_match(1).to_i.minutes.ago
        else Time.current
        end
      end
    end
  end
end
