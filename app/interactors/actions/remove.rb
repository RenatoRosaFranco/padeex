# frozen_string_literal: true

module Actions
  class Remove
    include Interactor

    def call
      context.record.destroy
      context.fail! unless context.record.destroyed?
    end
  end
end
