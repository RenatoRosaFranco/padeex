# frozen_string_literal: true

# OAuth-related behavior for User model.
module Omniauthable
  extend ActiveSupport::Concern

  class_methods do
    # @param auth [OmniAuth::AuthHash] OAuth callback data.
    # @return [User, nil]
    def from_omniauth(auth)
      result = Oauth::FindOrCreateUser.call(auth: auth)
      result.success? ? result.user : nil
    end
  end

  # @return [Boolean] true when the user has at least one linked OAuth identity
  def oauth_user?
    user_identities.any?
  end

  private

  # @return [Boolean] true when password is required (user did not sign up via OAuth)
  def password_required?
    !oauth_user?
  end
end
