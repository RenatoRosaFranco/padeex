# frozen_string_literal: true

# Landing page components.
module Landing
  # Features section for the landing page.
  class FeaturesComponent < ViewComponent::Base
    # Returns features list from app config. @return [Array]
    def features
      @features ||= AppConfigService.fetch(:features, default: [])
    end
  end
end
