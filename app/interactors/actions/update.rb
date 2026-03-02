# frozen_string_literal: true

module Actions
  # Updates an existing record with the given attributes.
  #
  # Context inputs:
  #   - record     [ActiveRecord::Base] record to update
  #   - attributes [Hash] attributes to apply via update
  class Update < BaseInteractor
    def call
      return if context.record.update(context.attributes)

      errors = context.record.errors.full_messages
      fail_with!(error: errors.join(", "), errors: errors)
    end
  end
end
