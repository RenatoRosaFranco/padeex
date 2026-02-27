# frozen_string_literal: true

# Renderiza o script do Google Analytics (GA4) quando GA_MEASUREMENT_ID está definido.
# Configure em .env: GA_MEASUREMENT_ID=G-XXXXXXXXXX
class GoogleAnalyticsComponent < ApplicationComponent
  def initialize(measurement_id: nil)
    @measurement_id = measurement_id.presence || ENV["GA_MEASUREMENT_ID"]
  end

  def render?
    @measurement_id.present?
  end
end
