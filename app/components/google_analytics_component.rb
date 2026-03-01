# frozen_string_literal: true

# Renders Google Analytics (GA4) script when GA_MEASUREMENT_ID is set.
# Configure in .env: GA_MEASUREMENT_ID=G-XXXXXXXXXX
class GoogleAnalyticsComponent < ApplicationComponent
  def initialize(measurement_id: nil)
    @measurement_id = measurement_id.presence || ENV["GA_MEASUREMENT_ID"]
  end

  def render?
    @measurement_id.present?
  end
end
