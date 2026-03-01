# frozen_string_literal: true

module Actions
  class Create
    include Interactor

    def call
      source = context.scope || context.model
      context.record = source.new(context.attributes || {})
      context.fail!(errors: context.record.errors.full_messages) unless context.record.save
    end
  end
end
