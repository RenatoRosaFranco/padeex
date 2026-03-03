# frozen_string_literal: true

# Booking schedule constants: slot duration, business hours, cancellation window.
# Include in models/services that need booking schedule configuration.
#
# @example
#   class Booking < ApplicationRecord
#     include BookingSchedule
#   end
module BookingSchedule
  extend ActiveSupport::Concern

  # Slot duration in minutes.
  SLOT_DURATION        = 60 
  # Cancellation window in hours before start.
  CANCELLATION_WINDOW  = 3
  # Business hours start in hours.
  BUSINESS_HOURS_START = 7 
  # Business hours end in hours.
  BUSINESS_HOURS_END   = 22
end
