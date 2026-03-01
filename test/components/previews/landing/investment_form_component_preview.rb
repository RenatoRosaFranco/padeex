# @label Investment Form
# @logical_path landing/investment_form
class Landing::InvestmentFormComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Vazio (novo)
  # Formulário de interesse de investidor sem dados preenchidos.
  def empty
    render Landing::InvestmentFormComponent.new
  end

  # @label Com dados
  # Formulário pré-preenchido com nome e e-mail.
  def with_data
    interest = InvestmentInterest.new(name: "João Silva", email: "joao@example.com")
    render Landing::InvestmentFormComponent.new(interest: interest)
  end
end
