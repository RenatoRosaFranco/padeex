# frozen_string_literal: true

# Base class for service objects. Provides the standard .call interface.
# Subclasses implement #call and receive keyword args via #initialize.
class ApplicationService
  # @param kwargs [Hash] keyword arguments passed to #initialize
  # @return [Object] result of #call
  def self.call(**kwargs)
    new(**kwargs).call
  end
end
