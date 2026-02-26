# frozen_string_literal: true

# Landing page components.
module Landing
  # Footer section for the landing page.
  class FooterComponent < ViewComponent::Base
    # Returns current year for copyright display. @return [Integer]
    def current_year
      Time.current.year
    end
  end
end
