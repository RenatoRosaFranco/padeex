# @label Suggestions (strip)
# @logical_path feed/suggestions
class Feed::SuggestionsComponentPreview < Lookbook::Preview
  layout "dashboard"

  # @label Default
  # Strip horizontal de sugestões de atletas para seguir.
  def default
    render Feed::SuggestionsComponent.new(suggestions: FeedSuggestionService.for_user(nil))
  end
end
