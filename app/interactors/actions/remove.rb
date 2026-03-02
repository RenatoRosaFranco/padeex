# frozen_string_literal: true

module Actions
  # Destroys a record. Fails if destruction is unsuccessful (e.g. blocked by callbacks).
  #
  # Context inputs:
  #   - record [ActiveRecord::Base] record to destroy
  class Remove < BaseInteractor
    def call
      context.record.destroy
      return if context.record.destroyed?

      fail_with!(error: I18n.t("errors.record_destroy_failed"))
    end
  end
end
