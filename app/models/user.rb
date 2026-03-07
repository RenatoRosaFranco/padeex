# frozen_string_literal: true

class User < ApplicationRecord
  include BelongsToTenant
  include Omniauthable

  # Enums
  enum :kind, { user: "user", club: "club", brand: "brand" }

  # Associations
  has_many :user_identities, dependent: :destroy
  has_many :bookings, dependent: :nullify
  has_many :courts, foreign_key: :club_id, dependent: :nullify
  has_many :tournaments, foreign_key: :club_id, dependent: :destroy
  has_many :instructors, foreign_key: :club_id, dependent: :destroy
  has_one  :instructor_profile, class_name: "Instructor", foreign_key: :user_id, dependent: :nullify
  has_one  :user_profile, dependent: :destroy
  has_one  :club_profile, dependent: :destroy
  has_one  :brand_profile, dependent: :destroy

  has_many :active_follows,  class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy
  
  has_many :following, -> { where(follows: { status: "accepted" }) },
           through: :active_follows, source: :followed
  has_many :followers, -> { where(follows: { status: "accepted" }) },
           through: :passive_follows, source: :follower
  
  has_many :follow_requests_received, -> { pending },
           class_name: "Follow", foreign_key: :followed_id
  
  has_many :follow_requests_sent, -> { pending },
           class_name: "Follow", foreign_key: :follower_id

  has_many :notifications, dependent: :destroy

  belongs_to :referrer, class_name: "User", foreign_key: :referred_by_id, optional: true
  has_many :referrals, class_name: "User", foreign_key: :referred_by_id, dependent: :nullify

  scope :pending_onboarding,    -> { where(onboarding_completed: false) }
  scope :newsletter_subscribers, -> { where(newsletter_subscribed: true) }

  attr_writer :referred_by_code

  # Callbacks
  before_create :assign_referral_code
  before_create :assign_unsubscribe_token
  before_create :resolve_referrer
  after_create_commit :send_welcome_email
  after_create_commit :send_newsletter_confirmation

  # Devise
  devise :two_factor_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :omniauthable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::JTIMatcher,
         omniauth_providers: %i[google_oauth2 facebook]

  # Validations
  validates :name,           presence: true, unless: :new_record?
  validates :password,       presence: true, if: :password_required?
  validates :accepted_terms, acceptance: true, on: :create

  # @return [String] user initials (first letters of the first two names)
  def initials
    return "?" if name.blank?
    name.split.first(2).map { |w| w[0] }.join.upcase
  end

  # @param other [User] User to check
  # @return [Boolean] true if following other with accepted status
  def following?(other)
    active_follows.accepted.exists?(followed_id: other.id)
  end

  # @param other [User] User to check
  # @return [Boolean] true if follow request to other is pending
  def requested?(other)
    active_follows.pending.exists?(followed_id: other.id)
  end

  # @param other [User] User to find follow record with
  # @return [Follow, nil] Follow record or nil if none exists
  def follow_record_with(other)
    active_follows.find_by(followed_id: other.id)
  end

  # @return [Boolean] true if the user is an admin
  def admin?
    admin
  end

  # Returns the profile for onboarding based on user kind (user, club, or brand).
  # @return [UserProfile, ClubProfile, BrandProfile]
  def onboarding_profile
    UserAccountProfile.new(account: self).profile
  end

  # Marks onboarding as completed.
  # @return [Boolean] true if saved
  def complete_onboarding!
    update!(onboarding_completed: true)
  end

  # Unsubscribes the user from the newsletter.
  # @return [Boolean] true if the update succeeded
  def unsubscribe!
    update!(newsletter_subscribed: false)
  end

  # @return [String] the full URL for registration with this user's referral code
  def referral_url
    Rails.application.routes.url_helpers.new_user_registration_url(ref: referral_code, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  private

  # Assigns a unique 8-character alphanumeric referral code. Skips if already set.
  def assign_referral_code
    self.referral_code ||= loop do
      code = SecureRandom.alphanumeric(8).upcase
      break code unless User.exists?(referral_code: code)
    end
  end

  # Resolves @referred_by_code to referred_by_id by looking up the referrer user.
  def resolve_referrer
    return if @referred_by_code.blank?
    self.referred_by_id ||= User.find_by(referral_code: @referred_by_code.upcase)&.id
  end

  # Assigns a unique URL-safe unsubscribe token. Skips if already set.
  def assign_unsubscribe_token
    self.unsubscribe_token ||= loop do
      token = SecureRandom.urlsafe_base64(32)
      break token unless User.exists?(unsubscribe_token: token)
    end
  end

  # Sends the welcome email asynchronously.
  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end

  # Sends the newsletter confirmation email asynchronously.
  def send_newsletter_confirmation
    UserMailer.newsletter_confirmation(self).deliver_later
  end
end
