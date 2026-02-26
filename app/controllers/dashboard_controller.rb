# frozen_string_literal: true

class DashboardController < ApplicationController
  include ReleasedAppGate

  before_action :authenticate_user!

  layout "dashboard"

  def index
  end
end
