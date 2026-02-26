# frozen_string_literal: true

class User < ApplicationRecord

  # Devise
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable

  # Validations
  validates :name, presence: true

  # Returns user initials.
  # @return [String] User initials.
  def initials
    name.split.first(2).map { |w| w[0] }.join.upcase
  end
end
