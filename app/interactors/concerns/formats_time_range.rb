# frozen_string_literal: true

# Shared helper for interactors that compare time ranges in SQL queries.
# Formats Time-like objects to "HH:MM:SS" strings as expected by PostgreSQL time columns.
module FormatsTimeRange
  private

  # @param time [Time, ActiveSupport::TimeWithZone]
  # @return [String] e.g. "14:30:00"
  def time_str(time)
    time.strftime("%H:%M:%S")
  end
end
