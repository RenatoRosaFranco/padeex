# @label Suggestion Card
# @logical_path feed/suggestion_card
class Feed::SuggestionCardComponentPreview < Lookbook::Preview
  layout "dashboard"

  # @label Default
  def default
    render Feed::SuggestionCardComponent.new(suggestion: suggestion)
  end

  private

  def suggestion
    FeedSuggestionService::FeedSuggestion.new(
      id: 101,
      name: "Pedro Alves",
      username: "pedropadel",
      initials: "PA",
      avatar_url: nil
    )
  end
end
