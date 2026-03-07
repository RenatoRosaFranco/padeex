# frozen_string_literal: true

# Base class for all interactors. Inherit from this instead of including Interactor directly.
#
# Provides two failure paths:
#   - fail_with!   — expected business failures: logs to Rails, captures to Sentry, fails context.
#   - track_error  — safety-net around callback for unexpected Interactor::Failure and
#                    StandardError; delegates logging and capture to Shared::FailInteractor.
class BaseInteractor
  include Interactor

  around :track_error

  private

  # Delegates unhandled Interactor::Failure and StandardError to Shared::FailInteractor,
  # which logs to Rails, captures to Sentry, and fails the context with a new failure.
  # Failures already logged (flagged with _logged_by_fail_interactor) are re-raised as-is.
  def track_error(interactor)
    interactor.call
  rescue Interactor::Failure => e
    raise if e.context._logged_by_fail_interactor

    Shared::FailInteractor.call(
      error: e.context.error.presence || e.message,
      source: e.context.source.presence || self.class.name,
      **e.context.to_h.except(:error, :source)
    )
  rescue StandardError => e
    Shared::FailInteractor.call(
      error: e.message,
      source: self.class.name,
      exception: e
    )
  end

  # Logs, captures to Sentry, and fails context in one call.
  # Replaces the verbose Shared::FailInteractor.call + context.fail! pair.
  #
  # @param error [String] human-readable failure message
  # @param extra [Hash] additional context keys forwarded to context.fail!
  def fail_with!(error:, **extra)
    Rails.logger.warn("[#{self.class.name}] #{error}")
    SentryFailureCaptureService.call(error: error, source: self.class.name, extra_context: extra)
    context.fail!(error: error, _logged_by_fail_interactor: true, **extra)
  end
end