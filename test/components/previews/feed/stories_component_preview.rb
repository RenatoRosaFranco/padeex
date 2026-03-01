# @label Stories (strip)
# @logical_path feed/stories
class Feed::StoriesComponentPreview < Lookbook::Preview
  layout "dashboard"

  # @label Default
  # Strip horizontal de stories com scroll. Inclui o viewer modal (Stimulus).
  def default
    render Feed::StoriesComponent.new(stories: FeedStoryService.for_user(nil))
  end
end
