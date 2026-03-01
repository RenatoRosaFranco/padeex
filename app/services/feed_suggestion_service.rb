# frozen_string_literal: true

class FeedSuggestionService
  FeedSuggestion = Struct.new(
    :id, :name, :username, :initials, :avatar_url,
    keyword_init: true
  )

  # TODO: replace mock with real query:
  #   User.not_followed_by(user)
  #     .where(onboarding_completed: true)
  #     .order_by_engagement
  #     .limit(12)
  def self.for_user(_user)
    mock_suggestions
  end

  class << self
    private

    def mock_suggestions
      [
        FeedSuggestion.new(id: 101, name: "Pedro Alves",      username: "pedropadel",   initials: "PA", avatar_url: nil),
        FeedSuggestion.new(id: 102, name: "Juliana Costa",    username: "jucosta",      initials: "JC", avatar_url: nil),
        FeedSuggestion.new(id: 103, name: "Ricardo Mendes",   username: "ricardopadel", initials: "RM", avatar_url: nil),
        FeedSuggestion.new(id: 104, name: "Fernanda Lima",    username: "ferpadel",     initials: "FL", avatar_url: nil),
        FeedSuggestion.new(id: 105, name: "Thiago Carvalho",  username: "thiagoc",      initials: "TC", avatar_url: nil),
        FeedSuggestion.new(id: 106, name: "Beatriz Nunes",    username: "bianunespadel",initials: "BN", avatar_url: nil),
        FeedSuggestion.new(id: 107, name: "Felipe Gomes",     username: "felipegpadel", initials: "FG", avatar_url: nil),
        FeedSuggestion.new(id: 108, name: "Larissa Moura",    username: "larissamoura", initials: "LM", avatar_url: nil),
        FeedSuggestion.new(id: 109, name: "Marcos Souza",     username: "marcospadel",  initials: "MS", avatar_url: nil),
        FeedSuggestion.new(id: 110, name: "Camila Teixeira",  username: "camilapadel",  initials: "CT", avatar_url: nil),
      ]
    end
  end
end
