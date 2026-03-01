# frozen_string_literal: true

class InvestmentInterestsController < ApplicationController
  include RecaptchaVerifiable
  layout "landing"

  verify_recaptcha only: [:create]

  def create
    result = Actions::Create.call(model: InvestmentInterest, attributes: interest_params)
    @success = result.success?
    @interest = result.record
    @error_msg = result.errors&.first unless @success

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
