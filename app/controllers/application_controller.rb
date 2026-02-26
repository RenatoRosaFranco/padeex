# frozen_string_literal: true

class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Redirect path after sign in.
  # @param resource [Object] Signed-in user.
  # @return [String] Redirect path after sign in.
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # Redirect path after sign out. 
  # @param resource_or_scope [Object] User or scope. 
  # @return [String] Redirect path after sign out.
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
