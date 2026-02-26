# frozen_string_literal: true

class User < ApplicationRecord
  include Omniauthable

  # Devise
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :omniauthable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::JTIMatcher,
         omniauth_providers: %i[google_oauth2 facebook]

  # Validations
  validates :name, presence: true
  validates :password, presence: true, if: :password_required?

  # @return [String] iniciais do usuário (primeiras letras dos dois primeiros nomes)
  def initials
    name.split.first(2).map { |w| w[0] }.join.upcase
  end
end
