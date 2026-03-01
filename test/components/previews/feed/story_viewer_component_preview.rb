# @label Story Viewer (modal)
# @logical_path feed/story_viewer
class Feed::StoryViewerComponentPreview < Lookbook::Preview
  layout "dashboard"

  # @label Default
  # Modal de visualização de stories. Aberto via JS (story_viewer_controller).
  #        Para visualizar: use o preview de Feed::StoriesComponent e clique em um story.
  def default
    render Feed::StoryViewerComponent.new
  end
end
