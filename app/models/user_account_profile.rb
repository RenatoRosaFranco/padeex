# frozen_string_literal: true

# Resolves the account profile for a user based on their kind (user, club, or brand).
# Finds existing profile or builds a new one.
#
# @example
#   profile = UserAccountProfile.new(account: current_user).profile
class UserAccountProfile
  # Constants
  PROFILE_TYPES = { user: :user, club: :club, brand: :brand }.freeze

  # @param account [User]
  def initialize(account:)
    @account = account
  end

  # Returns the profile for onboarding based on account kind.
  #
  # @return [UserProfile, ClubProfile, BrandProfile]
  def profile
    type = PROFILE_TYPES.fetch(@account.kind&.to_sym, :user)
    for_type(type)
  end

  # Returns the profile for the given type, finding or building it.
  #
  # @param type [Symbol] :user, :club, or :brand
  # @return [UserProfile, ClubProfile, BrandProfile]
  def for_type(type)
    @account.send("#{type}_profile") || @account.send("build_#{type}_profile")
  end
end
