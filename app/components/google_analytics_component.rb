# frozen_string_literal: true

# Renders Google Analytics (GA4) script when GA_MEASUREMENT_ID is set.
# Configure in .env: GA_MEASUREMENT_ID=G-XXXXXXXXXX
class GoogleAnalyticsComponent < ApplicationComponent
  # @param measurement_id [String, nil] GA4 measurement ID (falls back to ENV["GA_MEASUREMENT_ID"] if blank)
  def initialize(measurement_id: nil)
    @measurement_id = measurement_id.presence || ENV["GA_MEASUREMENT_ID"]
  end

  # @return [Boolean] whether the component should render (only when measurement_id is present)
  def render?
    @measurement_id.present?
  end
end
