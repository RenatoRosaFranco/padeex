# @label Story (item)
# @logical_path feed/story
class Feed::StoryComponentPreview < Lookbook::Preview
  layout "dashboard"

  # @label Não visto
  # Anel gradiente roxo→verde indica story não visualizado.
  def unseen
    render Feed::StoryComponent.new(story: story(seen: false), index: 0)
  end

  # @label Visto
  # Anel cinza indica story já visualizado.
  def seen
    render Feed::StoryComponent.new(story: story(seen: true), index: 0)
  end

  # @label Conta oficial
  def official
    render Feed::StoryComponent.new(story: story(seen: false, username: "padeex", initials: "PX"), index: 0)
  end

  private

  def story(seen:, username: "carlospadel", initials: "CS")
    FeedStoryService::FeedStory.new(
      id: 1,
      author_name: "Carlos Silva",
      author_username: username,
      author_initials: initials,
      author_avatar_url: nil,
      image_url: nil,
      gradient: "linear-gradient(135deg, #3628c5 0%, #4ade80 100%)",
      time_label: "2h",
      seen: seen
    )
  end
end
