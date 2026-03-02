# frozen_string_literal: true

module Feed
  # Provides follow suggestions for a given user.
  # Currently returns mock data; replace with real DB query when follow graph is ready.
  class SuggestionService
    Suggestion = Struct.new(
      :id, :name, :username, :initials, :avatar_url,
      keyword_init: true
    )

    # TODO: replace mock with real query:
    #   User.not_followed_by(user)
    #     .where(onboarding_completed: true)
    #     .order_by_engagement
    #     .limit(12)
    #
    # @param _user [User] current user (unused until real query is implemented)
    # @return [Array<Suggestion>]
    def self.for_user(_user)
      mock_suggestions
    end

    class << self
      private

      def mock_suggestions
        raw = JSON.parse(Rails.root.join("data/mocks/feed_suggestions.json").read)
        raw.map { |h| Suggestion.new(**h.transform_keys(&:to_sym)) }
      end
    end
  end
end
