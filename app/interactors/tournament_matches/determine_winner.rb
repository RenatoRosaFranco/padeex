# frozen_string_literal: true

module TournamentMatches
  # Determines the winner of a finished match based on home/away scores.
  # Returns nil when match is not finished or scores are missing.
  #
  # @example
  #   result = TournamentMatches::DetermineWinner.call(match: match)
  #   result.winner # => :home, :away, :draw, or nil
  class DetermineWinner < BaseInteractor
    delegate :match, to: :context

    def call
      context.winner = resolved_winner
    end

    private

    # @return [Symbol, nil] :home, :away, :draw, or nil when undetermined
    def resolved_winner
      return nil unless scores_available?

      winner_from_scores(match.home_score, match.away_score)
    end

    # @return [Boolean] true when match is finished and both scores present
    def scores_available?
      match.finished? && match.home_score.present? && match.away_score.present?
    end

    # @return [Symbol] :home, :away, or :draw
    def winner_from_scores(home_score, away_score)
      return :home if home_score > away_score
      return :away if away_score > home_score

      :draw
    end
  end
end
