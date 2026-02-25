# frozen_string_literal: true

module Landing
  class FooterComponent < ViewComponent::Base
    def current_year
      Time.current.year
    end
  end
end
