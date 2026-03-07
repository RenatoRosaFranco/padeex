# frozen_string_literal: true

class ClubProfile < ApplicationRecord
  # Associations
  belongs_to :user

  # Attachments
  has_one_attached :logo

  scope :mappable, -> { where.not(latitude: nil, longitude: nil) }

  # Validations
  validates :club_name, presence: true
  validates :cnpj,      presence: true
  validates :address,   presence: true
  validates :phone,     presence: true
  
  validates :cancellation_hours, 
            presence: true,
            numericality: { 
              only_integer: true, 
              greater_than: 0, 
              less_than_or_equal_to: 168 
            }
end
