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

  SLOT_DURATION        = 60 # minutes
  CANCELLATION_WINDOW  = 2  # hours before start
  BUSINESS_HOURS_START = 7  # 07:00
  BUSINESS_HOURS_END   = 22 # 22:00
end
