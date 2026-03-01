# frozen_string_literal: true

# Represents a sport/vertical in the multi-tenant app (padel, handball, football, futsal).
# Content, waitlist, and users can be scoped per tenant.
#
# @example
#   Tenant.find_by(slug: "padel")
#   Current.tenant
class Tenant < ApplicationRecord
  # Associations
  has_many :waitlist_entries, dependent: :nullify
  has_many :investment_interests, dependent: :nullify
  has_many :posts, dependent: :nullify
  has_many :users, dependent: :nullify
  has_many :courts, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :time_blocks, dependent: :destroy

  # Validations
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true

  # @return [Tenant, nil] default tenant (padel) or first available
  def self.default
    find_by(slug: "padel") || first
  end

  # @return [ActiveRecord::Relation<User>] clubs associated with the tenant
  def clubs
    User.where(kind: :club, tenant_id: id)
  end
end
