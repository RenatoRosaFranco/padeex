# frozen_string_literal: true

class BrandProfile < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :products,            class_name: "BrandProduct",         dependent: :destroy
  has_many :product_categories,  class_name: "BrandProductCategory",  dependent: :destroy
  has_many :integrations,        class_name: "BrandIntegration",      dependent: :destroy

  # Attachments
  has_one_attached :logo

  # Validations
  validates :brand_name, presence: true
  validates :cnpj,       presence: true
  validates :category,   presence: true
end
