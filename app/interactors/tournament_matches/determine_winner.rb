# frozen_string_literal: true

module TournamentMatches
  # Determines the winner of a finished match based on home/away scores.
  #
  # @example
  #   result = TournamentMatches::DetermineWinner.call(match: match)
  #   result.winner # => :home, :away, :draw, or nil
  class DetermineWinner < BaseInteractor
    delegate :match, to: :context

    def call
      context.winner = compute_winner
    end

    private

    def compute_winner
      return nil unless match.finished? && match.home_score.present? && match.away_score.present?
      return :home if match.home_score > match.away_score
      return :away if match.away_score > match.home_score
      :draw
    end
  end
end
