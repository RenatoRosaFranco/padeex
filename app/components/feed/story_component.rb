# frozen_string_literal: true

module Feed
  class StoryComponent < ApplicationComponent
    def initialize(story:, index:)
      @story = story
      @index = index
    end

    private

    attr_reader :story, :index

    def ring_class
      story.seen ? "fst__ring fst__ring--seen" : "fst__ring"
    end
  end
end
