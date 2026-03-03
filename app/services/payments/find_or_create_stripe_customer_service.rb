# frozen_string_literal: true

module Payments
  # Finds or creates a Stripe Customer for a user.
  # Persists stripe_customer_id on the user when creating.
  #
  # @example
  #   customer_id = Payments::FindOrCreateStripeCustomerService.call(user: current_user)
  class FindOrCreateStripeCustomerService < ApplicationService
    # @param user [User]
    def initialize(user:)
      @user = user
    end

    # Returns Stripe Customer ID (cus_xxx). Creates customer in Stripe if user has none.
    #
    # @return [String]
    def call
      return @user.stripe_customer_id if @user.stripe_customer_id.present?

      customer = Stripe::Customer.create(
        email: @user.email,
        name:  @user.name.presence
      )

      @user.update!(stripe_customer_id: customer.id)
      customer.id
    end
  end
end
