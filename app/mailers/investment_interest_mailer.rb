# frozen_string_literal: true

class InvestmentInterestMailer < ApplicationMailer
  # Notifies team of new investment interest.
  # @param interest [InvestmentInterest] Submitted investment interest
  # @return [Mail::Message]
  def new_interest(interest)
    @interest = interest
    mail(
      to:       "contato@padeex.com.br",
      reply_to: @interest.email,
      subject:  "[PADEX] Nova proposta de investimento — #{full_name(@interest)}"
    )
  end

  # Sends confirmation to the user who submitted the investment interest.
  # @param interest [InvestmentInterest] Submitted investment interest
  # @return [Mail::Message]
  def confirmation(interest)
    @interest = interest
    mail(
      to:      @interest.email,
      subject: "Recebemos sua proposta, #{@interest.first_name}."
    )
  end

  private

  # @param interest [InvestmentInterest] Submitted investment interest
  # @return [String] Full name of the investor
  def full_name(interest)
    [interest.first_name, interest.last_name].join(" ")
  end
end
