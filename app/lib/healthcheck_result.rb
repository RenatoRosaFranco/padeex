# frozen_string_literal: true

# Value object for healthcheck API response.
HealthcheckResult = Struct.new(:status, :timestamp, :version, keyword_init: true) do
  def self.current
    new(
      status: "ok",
      timestamp: Time.current.iso8601,
      version: "1.0"
    )
  end
end
