# frozen_string_literal: true

module Feed
  class StoriesComponent < ApplicationComponent
    def initialize(stories:)
      @stories = stories
    end

    private

    attr_reader :stories

    def stories_json
      stories.map.with_index do |s, i|
        {
          index:      i,
          name:       s.author_name,
          username:   s.author_username,
          initials:   s.author_initials,
          avatar_url: s.author_avatar_url,
          image_url:  s.image_url,
          gradient:   s.gradient,
          time_label: s.time_label,
          seen:       s.seen
        }
      end.to_json
    end
  end
end
