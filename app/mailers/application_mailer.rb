# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "nao-responda@padeex.com.br"
  layout "mailer"
end
