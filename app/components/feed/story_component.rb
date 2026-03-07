# frozen_string_literal: true

module Feed
  class StoryComponent < ApplicationComponent
    def initialize(story:, index:)
      @story = story
      @index = index
    end

    private

    attr_reader :story, :index

    # @return [String] CSS classes for the story ring ("fst__ring fst__ring--seen" if seen, "fst__ring" otherwise)
    def ring_class
      story.seen ? "fst__ring fst__ring--seen" : "fst__ring"
    end
  end
end
