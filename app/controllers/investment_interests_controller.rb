# frozen_string_literal: true

class InvestmentInterestsController < ApplicationController
  layout "landing"

  def create
    @interest = InvestmentInterest.new(interest_params)
    @success = @interest.save
    @error_msg = @interest.errors.full_messages.first unless @success

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to para_investidores_path }
    end
  end

  private

  def interest_params
    params.permit(:first_name, :last_name, :email, :phone, :investment_range, :message)
  end
end
