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

  # @return [Boolean] true se o usuário possui ao menos uma identidade OAuth vinculada
  def oauth_user?
    user_identities.any?
  end

  private

  # @return [Boolean] true se senha é obrigatória (usuário não veio de OAuth)
  def password_required?
    !oauth_user?
  end
end
