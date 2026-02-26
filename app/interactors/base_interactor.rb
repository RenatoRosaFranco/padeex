# frozen_string_literal: true

# Base interactor class. Captures failures and errors to Sentry.
class BaseInteractor
  include Interactor

  around :track_error

  private

  # Captures Interactor::Failure and StandardError, then re-raises.
  def track_error(interactor)
    interactor.call
  rescue Interactor::Failure => e
    Sentry.capture_exception(e)
    raise
  rescue StandardError => e
    Sentry.capture_exception(e)
    raise
  end
end