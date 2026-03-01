# frozen_string_literal: true

module Actions
  class Find
    include Interactor

    def call
      context.record = context.scope.find(context.id)
    rescue ActiveRecord::RecordNotFound
      context.fail!
    end
  end
end
