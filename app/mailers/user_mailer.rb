# frozen_string_literal: true

class UserMailer < ApplicationMailer
  # Sends welcome email to newly registered user.
  # @param user [User] Newly registered user
  # @return [Mail::Message]
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Bem-vindo ao PADEX, #{@user.name.split.first}!")
  end

  def newsletter_confirmation(user)
    @user = user
    @unsubscribe_url = newsletter_unsubscribe_url(user.unsubscribe_token)
    mail(to: @user.email, subject: "Você está inscrito nas novidades do PADEX")
  end

  def onboarding_reminder(user)
    @user = user
    @days = user.onboarding_days_remaining
    @onboarding_url = edit_onboarding_personal_info_url
    mail(to: @user.email, subject: "Você tem #{@days} #{@days == 1 ? 'dia' : 'dias'} para finalizar seu cadastro no PADEX")
  end

  def onboarding_final_reminder(user)
    @user = user
    @onboarding_url = edit_onboarding_personal_info_url
    mail(to: @user.email, subject: "Último aviso: finalize seu cadastro hoje ou sua conta será excluída")
  end
end
