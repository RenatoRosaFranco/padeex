# @label Google Analytics
class GoogleAnalyticsComponentPreview < Lookbook::Preview
  # @label Com Measurement ID
  # Renderiza o script GA4 quando um ID é fornecido.
  def with_id
    render GoogleAnalyticsComponent.new(measurement_id: "G-XXXXXXXXXX")
  end

  # @label Sem Measurement ID
  # Não renderiza nada (render? retorna false).
  def without_id
    render GoogleAnalyticsComponent.new(measurement_id: nil)
  end
end
