# frozen_string_literal: true

module Shared
  # Internal safety-net used by BaseInteractor#track_error to log and capture
  # unhandled Interactor::Failure and StandardError exceptions.
  #
  # In normal interactor code use +BaseInteractor#fail_with!+ instead, which logs,
  # captures to Sentry, and fails the context in a single call without indirection.
  #
  # @example Called automatically by BaseInteractor — do not call directly in subclasses.
  class FailInteractor
    include Interactor
    delegate :error, to: :context

    def call
      context.error = context.error.presence || I18n.t("errors.internal", default: "Internal error")
      capture_to_rails
      capture_to_sentry
  
      context.fail!(**fail_params.merge(_logged_by_fail_interactor: true))
    end

    private

    # @return [void]
    def capture_to_rails
      Rails.logger.warn("[#{source}] #{error}")
    end

    # @return [void]
    def capture_to_sentry
      SentryFailureCaptureService.call(
        error:         error,
        source:        source,
        extra_context: context.to_h.except(:error, :source, :exception, :_logged_by_fail_interactor),
        exception:     (context.exception if context.respond_to?(:exception))
      )
    end

    # @return [String]
    def source
      context.source.presence || "unknown"
    end

    # @return [Hash] Params to pass to context.fail!
    def fail_params
      context.to_h.except(:source, :exception, :_logged_by_fail_interactor).compact
    end
  end
end
