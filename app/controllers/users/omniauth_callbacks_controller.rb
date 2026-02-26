# frozen_string_literal: true

# Handles OAuth callbacks from Google and Facebook.
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  layout "auth"

  # Google OAuth2 callback.
  # @return [void]
  def google_oauth2
    handle_callback("Google")
  end

  # Facebook OAuth callback.
  # @return [void]
  def facebook
    handle_callback("Facebook")
  end

  # Redirects to login on OAuth failure.
  # @return [void]
  def failure
    redirect_to new_user_session_path, alert: t("devise.omniauth_callbacks.failure")
  end

  private

  # Signs in or creates user from OAuth data.
  # @param provider_name [String] Provider display name.
  # @return [void]
  def handle_callback(provider_name)
    result = Oauth::HandleCallback.call(auth: request.env["omniauth.auth"])

    if result.success?
      sign_in_and_redirect result.user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      flash[:alert] = t("devise.omniauth_callbacks.failure")
      redirect_to new_user_session_path
    end
  end
end
