# frozen_string_literal: true

class InvestmentInterestMailer < ApplicationMailer
  def new_interest(interest)
    @interest = interest
    mail(
      to:       "contato@padeex.com.br",
      reply_to: @interest.email,
      subject:  "[PADEX] Nova proposta de investimento — #{@interest.first_name} #{@interest.last_name}"
    )
  end

  def confirmation(interest)
    @interest = interest
    mail(
      to:      @interest.email,
      subject: "Recebemos sua proposta, #{@interest.first_name}."
    )
  end
end
