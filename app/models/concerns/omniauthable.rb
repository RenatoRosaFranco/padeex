# frozen_string_literal: true

# OAuth-related behavior for User model.
module Omniauthable
  extend ActiveSupport::Concern

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
