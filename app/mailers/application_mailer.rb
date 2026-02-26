# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@padeex.com.br"
  layout "mailer"
end
