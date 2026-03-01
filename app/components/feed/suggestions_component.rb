# frozen_string_literal: true

module Feed
  class SuggestionsComponent < ApplicationComponent
    def initialize(suggestions:)
      @suggestions = suggestions
    end

    private

    attr_reader :suggestions
  end
end
