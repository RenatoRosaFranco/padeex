# frozen_string_literal: true

class AnalyticsController < ApplicationController
  include ReleasedAppGate

  before_action :authenticate_user!

  layout "dashboard"

  def index
  end
end
