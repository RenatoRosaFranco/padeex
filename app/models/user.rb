# frozen_string_literal: true

class User < ApplicationRecord
  include Omniauthable

  # Associations
  has_many :user_identities, dependent: :destroy

  after_create_commit :send_welcome_email

  # Devise
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :omniauthable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::JTIMatcher,
         omniauth_providers: %i[google_oauth2 facebook]

  # Validations
  validates :name, presence: true
  validates :password, presence: true, if: :password_required?

  def initials
    name.split.first(2).map { |w| w[0] }.join.upcase
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end
end
