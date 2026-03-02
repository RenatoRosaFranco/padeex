# frozen_string_literal: true

class WaitlistsController < ApplicationController
  include RecaptchaVerifiable
  layout "landing"

  verify_recaptcha only: [:create]

  def create
    result = Actions::Create.call(scope: WaitlistEntry, attributes: { email: params[:email] })
    @success = result.success?
    @error_msg = result.errors&.first unless @success

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end
end
