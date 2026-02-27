# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Bem-vindo ao PADEX, #{@user.name.split.first}!")
  end
end
