# frozen_string_literal: true

module Feed
  class SuggestionCardComponent < ApplicationComponent
    def initialize(suggestion:)
      @suggestion = suggestion
    end

    private

    attr_reader :suggestion
  end
end
