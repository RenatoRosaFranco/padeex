# frozen_string_literal: true

class User < ApplicationRecord
  include BelongsToTenant
  include Omniauthable

  # Enums
  enum :kind, { user: "user", club: "club" }

  # Associations
  has_many :user_identities, dependent: :destroy
  has_many :bookings, dependent: :nullify
  has_many :courts, foreign_key: :club_id, dependent: :nullify
  has_many :tournaments, foreign_key: :club_id, dependent: :destroy
  has_many :instructors, foreign_key: :club_id, dependent: :destroy
  has_one  :instructor_profile, class_name: "Instructor", foreign_key: :user_id, dependent: :nullify
  has_one  :user_profile, dependent: :destroy
  has_one  :club_profile, dependent: :destroy

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

  # Callbacks
  after_create_commit :send_welcome_email

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

  # @return [UserProfile, ClubProfile] profile for onboarding (user_profile or club_profile)
  def onboarding_profile
    club? ? (club_profile || build_club_profile) : (user_profile || build_user_profile)
  end

  # Marks onboarding as completed.
  # @return [Boolean] true if saved
  def complete_onboarding!
    update!(onboarding_completed: true)
  end

  private

  # Sends welcome email asynchronously after user creation.
  # @return [void]
  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end
end
