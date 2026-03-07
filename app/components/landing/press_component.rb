# frozen_string_literal: true

module Landing
  class PressComponent < ::ApplicationComponent
    def outlets
      @outlets ||= YAML.load_file(
        Rails.root.join("data/press.yml"), symbolize_names: true
      ).fetch(:press, [])
    end
  end
end
