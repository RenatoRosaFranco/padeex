# frozen_string_literal: true

# Value object for healthcheck API response.
# @attr status [String] Health status (e.g. "ok")
# @attr timestamp [String] ISO8601 timestamp
# @attr version [String] API version
HealthcheckResult = Struct.new(:status, :timestamp, :version, keyword_init: true) do
  # @return [HealthcheckResult] Current health status with ok status and ISO8601 timestamp
  def self.current
    new(
      status: "ok",
      timestamp: Time.current.iso8601,
      version: "1.0"
    )
  end
end
