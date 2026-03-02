# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Discard jobs whose serialized ActiveRecord argument no longer exists.
  # Without this, a missing record raises DeserializationError on every retry attempt.
  discard_on ActiveJob::DeserializationError

  # Retry on transient infrastructure failures with exponential back-off.
  retry_on ActiveRecord::Deadlocked,       wait: :polynomially_longer, attempts: 3
  retry_on ActiveRecord::LockWaitTimeout,  wait: :polynomially_longer, attempts: 3
end
