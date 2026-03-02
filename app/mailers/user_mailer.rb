# frozen_string_literal: true

class UserMailer < ApplicationMailer
  # Sends welcome email to newly registered user.
  # @param user [User] Newly registered user
  # @return [Mail::Message]
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Bem-vindo ao PADEX, #{@user.name.split.first}!")
  end
end
