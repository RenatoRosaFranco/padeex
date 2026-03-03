# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SetTenant

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Browser support
  allow_browser versions: :modern

  # Callbacks
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end

  # Sets the locale based on the user's browser language.
  # @return [void]
  def set_locale
    I18n.locale = I18n.default_locale
  end

  # Redirect path after sign in.
  # @param resource [Object] Signed-in user.
  # @return [String] Redirect path after sign in.
  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && !resource.onboarding_completed?
      edit_onboarding_personal_info_path
    else
      dashboard_path
    end
  end

  # Redirect path after sign out. 
  # @param resource_or_scope [Object] User or scope. 
  # @return [String] Redirect path after sign out.
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
