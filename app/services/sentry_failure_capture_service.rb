# frozen_string_literal: true

# Captures interactor failures to Sentry (exception or message).
#
# @example With exception (full stack trace)
#   SentryFailureCaptureService.call(error: "x", source: "MyInteractor", exception: e)
#
# @example Message only
#   SentryFailureCaptureService.call(error: "x", source: "MyInteractor", extra_context: { key: "value" })
class SentryFailureCaptureService < ApplicationService
  # @param error         [String]         Error message
  # @param source        [String]         Source of the failure (e.g. interactor class name)
  # @param extra_context [Hash]           Optional extra context
  # @param exception     [Exception, nil] When present, uses capture_exception for full stack trace
  def initialize(error:, source: "unknown", extra_context: {}, exception: nil)
    @error         = error
    @source        = source
    @extra_context = extra_context
    @exception     = exception
  end

  # @return [void]
  def call
    if @exception
      Sentry.capture_exception(@exception, extra: extra)
    else
      Sentry.capture_message(
        "Interactor failure: #{@error}", level: :warning, extra: extra
      )
    end
  end

  private

  # @return [Hash]
  def extra
    {
      source:  @source,
      error:   @error,
      context: @extra_context
    }
  end
end
