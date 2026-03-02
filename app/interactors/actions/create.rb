# frozen_string_literal: true

module Actions
  # Instantiates and persists a new record within a given scope.
  #
  # Context inputs:
  #   - scope      [ActiveRecord::Relation, Class] AR class or scoped relation to build from
  #   - attributes [Hash] attributes to pass to .new
  #
  # Context outputs:
  #   - record [ActiveRecord::Base] the built record (persisted or with errors on failure)
  class Create < BaseInteractor
    def call
      context.record = context.scope.new(context.attributes || {})
      return if context.record.save

      errors = context.record.errors.full_messages
      fail_with!(error: errors.join(", "), errors: errors)
    end
  end
end
