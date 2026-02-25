# frozen_string_literal: true

module Landing
  class FeaturesComponent < ViewComponent::Base
    CONFIG_PATH = Rails.root.join("data/app_config.yml")

    def features
      @features ||= YAML.load_file(CONFIG_PATH, symbolize_names: true).dig(:features) || []
    end
  end
end
