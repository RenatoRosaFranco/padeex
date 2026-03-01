# frozen_string_literal: true

# Base class for service objects. Provides the standard .call interface.
# Subclasses implement #call and receive keyword args via #initialize.
#
# @example
#   class MyService < ApplicationService
#     def initialize(foo:, bar: nil)
#       @foo = foo
#       @bar = bar
#     end
#
#     def call
#       # ...
#     end
#   end
#
#   MyService.call(foo: "x", bar: "y")
class ApplicationService
  # @param kwargs [Hash] keyword arguments passed to #initialize
  # @return [Object] result of #call
  def self.call(**kwargs)
    new(**kwargs).call
  end
end
