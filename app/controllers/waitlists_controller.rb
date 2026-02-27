# frozen_string_literal: true

class WaitlistsController < ApplicationController
  include RecaptchaVerifiable
  layout "landing"

  verify_recaptcha only: [:create]

  def create
    @entry = WaitlistEntry.new(email: params[:email])
    @success = @entry.save
    @error_msg = @entry.errors.full_messages.first unless @success

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end
end
