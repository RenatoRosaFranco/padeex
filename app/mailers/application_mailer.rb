# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "noreply@padeex.app"
  layout "mailer"
end
