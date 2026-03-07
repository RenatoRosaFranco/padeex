# frozen_string_literal: true

class Dashboard::Brands::LookerController < Dashboard::Brands::BaseController
  def index
    @query = params[:q].to_s.strip
    @results = mock_results(@query) if @query.present?
  end

  private

  def mock_results(query)
    products = [
      { name: "Raquete Pro Carbon 360", category: "Raquetes", brand: "Bullpadel", price: "R$ 899,00", rating: 4.8, sold: 342 },
      { name: "Tênis React Padel", category: "Calçados", brand: "Nike", price: "R$ 649,00", rating: 4.6, sold: 218 },
      { name: "Bola Premium X3", category: "Bolas", brand: "Head", price: "R$ 49,90", rating: 4.9, sold: 1204 },
      { name: "Bag Pro Tour", category: "Acessórios", brand: "Wilson", price: "R$ 349,00", rating: 4.5, sold: 87 },
      { name: "Luva Grip Comfort", category: "Acessórios", brand: "Adidas", price: "R$ 59,90", rating: 4.3, sold: 560 },
      { name: "Camiseta Dry Fit Padel", category: "Vestuário", brand: "Lacoste", price: "R$ 199,00", rating: 4.7, sold: 391 },
    ]

    products.select { |p| p[:name].downcase.include?(query.downcase) || p[:category].downcase.include?(query.downcase) || p[:brand].downcase.include?(query.downcase) }
  end
end
