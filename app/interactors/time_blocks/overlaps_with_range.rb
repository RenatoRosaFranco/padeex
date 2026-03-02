# frozen_string_literal: true

module TimeBlocks
  # Checks if any time block overlaps with the given range for a court and date.
  # Overlap: block starts before range ends AND block ends after range starts.
  #
  # @example
  #   result = TimeBlocks::OverlapsWithRange.call(
  #     court_id: 1, date: Date.current,
  #     starts_at: Time.current, ends_at: 1.hour.from_now
  #   )
  #   result.overlaps # => true/false
  class OverlapsWithRange < BaseInteractor
    include FormatsTimeRange

    delegate :court_id, :date, :starts_at, :ends_at, to: :context

    def call
      context.overlaps = overlapping_block_exists?
    end

    private

    # @return [Boolean]
    def overlapping_block_exists?
      return false unless court_id && date && starts_at && ends_at

      starts = time_str(starts_at)
      ends   = time_str(ends_at)

      TimeBlock.where(court_id: court_id, date: date)
               .where("starts_at < ? AND ends_at > ?", ends, starts)
               .exists?
    end
  end
end
