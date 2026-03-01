# frozen_string_literal: true

module Actions
  class Update
    include Interactor

    def call
      context.fail!(errors: context.record.errors.full_messages) unless context.record.update(context.attributes)
    end
  end
end
