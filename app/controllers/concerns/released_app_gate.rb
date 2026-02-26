# frozen_string_literal: true

# Restricts access when app is not released (Flipper :released_app).
module ReleasedAppGate
  extend ActiveSupport::Concern

  included do
    before_action :require_app_released!
  end

  private

  # Redirects to root unless :released_app feature is enabled.
  def require_app_released!
    redirect_to root_path unless Flipper.enabled?(:released_app)
  end
end
