# frozen_string_literal: true

module Landing
  class TestimonialsComponent < ::ApplicationComponent
    def testimonials
      @testimonials ||= YAML.load_file(
        Rails.root.join("data/testimonials.yml"), symbolize_names: true
      ).fetch(:testimonials, [])
    end

    def row_one
      testimonials.first(testimonials.size / 2 + testimonials.size % 2)
    end

    def row_two
      testimonials.last(testimonials.size / 2)
    end

    def initials(name)
      name.split.first(2).map { |w| w[0] }.join.upcase
    end
  end
end
